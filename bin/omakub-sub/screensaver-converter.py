#!/usr/bin/env python3
import sys
import os
import shutil
import math
import random

try:
    from PIL import Image
except ImportError:
    venv_site = os.path.expanduser("~/.local/share/pipx/venvs/terminaltexteffects/lib")
    if os.path.isdir(venv_site):
        for root, dirs, files in os.walk(venv_site):
            if "site-packages" in dirs:
                sys.path.append(os.path.join(root, "site-packages"))
                break
    try:
        from PIL import Image
    except ImportError:
        Image = None

# Shared single source of truth for color gradients (used by screensaver and header)
GRADIENTS = [
    [(168, 85, 247), (59, 130, 246), (6, 182, 212)],                   # 0: Purple -> Blue -> Cyan (Cyberpunk / Synthwave)
    [(251, 191, 36), (249, 115, 22), (239, 68, 68), (217, 70, 239)], # 1: Sunset Gold -> Orange -> Coral -> Magenta
    [(132, 204, 22), (16, 185, 129), (20, 184, 166), (6, 182, 212)], # 2: Lime -> Emerald -> Teal -> Cyan
    [(244, 63, 94), (225, 29, 72), (147, 51, 234), (79, 70, 229)],   # 3: Coral -> Rose -> Purple -> Indigo
    [(0, 242, 254), (79, 172, 254), (99, 102, 241), (236, 72, 153)], # 4: Electric Cyan -> Royal Blue -> Indigo -> Hot Pink
    [(255, 107, 107), (255, 230, 109), (78, 205, 196)],               # 5: Coral -> Gold -> Aquamarine Mint
]

def interpolate_palette(palette, t):
    t = max(0.0, min(1.0, t))
    n = len(palette) - 1
    idx = int(t * n)
    if idx >= n:
        return palette[-1]
    sub = (t * n) - idx
    c1, c2 = palette[idx], palette[idx + 1]
    return (
        int(c1[0] + (c2[0] - c1[0]) * sub),
        int(c1[1] + (c2[1] - c1[1]) * sub),
        int(c1[2] + (c2[2] - c1[2]) * sub),
    )

def resolve_angle(angle=None):
    if angle is None or angle == "" or str(angle).lower() == "random":
        env_angle = os.environ.get("OMAKUB_GRADIENT_ANGLE")
        if env_angle:
            angle = env_angle
        else:
            angle = random.choice([0, 45, 90, 135, 180, 225, 270, 315, "radial", "radial-inv"])

    if isinstance(angle, str):
        angle_lower = angle.lower().strip()
        if angle_lower in ["radial", "radial-inv"]:
            return angle_lower
        elif angle_lower in ["horizontal", "right", "east"]:
            return 0.0
        elif angle_lower in ["horizontal-inv", "left", "west"]:
            return 180.0
        elif angle_lower in ["vertical", "down", "south"]:
            return 90.0
        elif angle_lower in ["vertical-inv", "up", "north"]:
            return 270.0
        elif angle_lower in ["diagonal", "down-right", "southeast"]:
            return 45.0
        elif angle_lower in ["up-right", "northeast"]:
            return 315.0
        elif angle_lower in ["down-left", "southwest"]:
            return 135.0
        elif angle_lower in ["up-left", "northwest"]:
            return 225.0
        else:
            try:
                return float(angle)
            except ValueError:
                return 45.0
    return float(angle)

def compute_gradient_t(tx, ty, angle):
    if angle == "radial":
        dx = tx - 0.5
        dy = ty - 0.5
        return max(0.0, min(1.0, math.sqrt(dx * dx + dy * dy) / 0.7071))
    elif angle == "radial-inv":
        dx = tx - 0.5
        dy = ty - 0.5
        return max(0.0, min(1.0, 1.0 - (math.sqrt(dx * dx + dy * dy) / 0.7071)))

    try:
        rad = math.radians(float(angle))
        cos_a = math.cos(rad)
        sin_a = math.sin(rad)
        proj = (tx - 0.5) * cos_a + (ty - 0.5) * sin_a
        max_d = 0.5 * (abs(cos_a) + abs(sin_a))
        if max_d <= 0:
            return 0.5
        return max(0.0, min(1.0, 0.5 + (proj / (2.0 * max_d))))
    except Exception:
        return tx * 0.35 + ty * 0.65

def text_to_ascii_gradient(text_file_path, gradient_index=0, version_tag=None, angle=None):
    angle = resolve_angle(angle)

    try:
        with open(text_file_path, "r", encoding="utf-8", errors="ignore") as f:
            raw_lines = [line.rstrip("\r\n") for line in f]
    except Exception:
        return "██████"

    while raw_lines and not raw_lines[0].strip():
        raw_lines.pop(0)
    while raw_lines and not raw_lines[-1].strip():
        raw_lines.pop()

    if not raw_lines:
        return "██████"

    max_w = max(len(line) for line in raw_lines)
    max_h = len(raw_lines)

    palette = GRADIENTS[int(gradient_index) % len(GRADIENTS)]
    lines = []

    for y, line in enumerate(raw_lines):
        line_chars = []
        for x, ch in enumerate(line):
            if ch == " ":
                line_chars.append(" ")
            else:
                tx = x / max(1, max_w - 1)
                ty = y / max(1, max_h - 1)
                t = compute_gradient_t(tx, ty, angle)
                r, g, b = interpolate_palette(palette, t)
                line_chars.append(f"\033[38;2;{r};{g};{b}m{ch}\033[0m")
        lines.append("".join(line_chars))

    if version_tag:
        last_r, last_g, last_b = palette[-1]
        pad = " " * max(0, max_w - len(f"v{version_tag}"))
        lines.append(f"{pad}\033[38;2;{last_r};{last_g};{last_b}mv{version_tag}\033[0m")

    return "\n".join(lines)

def image_to_ascii(image_path, max_width=None, max_height=None, gradient_index=0, version_tag=None, angle=None):
    angle = resolve_angle(angle)

    if not os.path.isfile(image_path) or Image is None:
        return text_to_ascii_gradient(image_path, gradient_index, version_tag, angle)

    term_size = shutil.get_terminal_size((80, 24))
    max_width = max(10, max_width or int(term_size.columns * 0.55))
    max_height = max(5, max_height or int(term_size.lines * 0.45))

    try:
        img = Image.open(image_path).convert("RGBA")
    except Exception:
        return text_to_ascii_gradient(image_path, gradient_index, version_tag, angle)

    w, h = img.size
    pixels = img.load()

    # Detect background characteristics from outer border
    border = [pixels[x, 0] for x in range(w)] + [pixels[x, h - 1] for x in range(w)] + \
             [pixels[0, y] for y in range(h)] + [pixels[w - 1, y] for y in range(h)]

    has_alpha = sum(1 for p in border if p[3] < 50) > (len(border) * 0.3)
    avg_br = sum(p[0] for p in border) / len(border)
    avg_bg = sum(p[1] for p in border) / len(border)
    avg_bb = sum(p[2] for p in border) / len(border)
    border_lum = 0.299 * avg_br + 0.587 * avg_bg + 0.114 * avg_bb
    is_light_bg = (border_lum > 120) and not has_alpha

    # 1. Pre-crop content bounding box in full resolution
    min_x, max_x = w, -1
    min_y, max_y = h, -1
    stride = max(1, min(w, h) // 400)

    for y in range(0, h, stride):
        for x in range(0, w, stride):
            r, g, b, a = pixels[x, y]
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            if has_alpha:
                is_fg = a > 60
            elif is_light_bg:
                is_fg = lum < border_lum - 50
            else:
                is_fg = lum > border_lum + 50

            if is_fg:
                min_x, max_x = min(min_x, x), max(max_x, x)
                min_y, max_y = min(min_y, y), max(max_y, y)

    if max_x > min_x and max_y > min_y:
        pad_x = max(1, int((max_x - min_x) * 0.01))
        pad_y = max(1, int((max_y - min_y) * 0.01))
        crop_box = (max(0, min_x - pad_x), max(0, min_y - pad_y), min(w, max_x + pad_x), min(h, max_y + pad_y))
        img = img.crop(crop_box)

    # 2. Dynamic aspect-ratio preserving scaling (Terminal characters are ~2:1 height/width ratio)
    cw, ch = img.size
    CELL_ASPECT = 2.0  # character height / width in standard monospace fonts

    # Compute optimal dimensions that fit within (max_width, max_height) without stretching
    target_w = max_width
    target_h = max(3, int(round((target_w * ch) / (cw * CELL_ASPECT))))

    if target_h > max_height:
        target_h = max_height
        target_w = max(4, int(round((target_h * cw * CELL_ASPECT) / ch)))

    new_w = max(4, min(max_width, target_w))
    new_h = max(3, min(max_height, target_h))

    # Use BOX area-averaging downsampling to eliminate anti-aliasing blur halos between letters
    img_resized = img.resize((new_w, new_h), Image.Resampling.BOX)
    r_pixels = img_resized.load()

    # 3. Dynamic contrast thresholding tuned to eliminate anti-aliasing bleeding
    all_lums = [0.299 * r_pixels[x, y][0] + 0.587 * r_pixels[x, y][1] + 0.114 * r_pixels[x, y][2]
                for x in range(new_w) for y in range(new_h)]
    min_lum = min(all_lums)
    max_lum = max(all_lums)
    cutoff = min_lum + (max_lum - min_lum) * 0.50

    fg_mask = [[False for _ in range(new_w)] for _ in range(new_h)]
    box_min_x, box_max_x = new_w, -1
    box_min_y, box_max_y = new_h, -1

    for y in range(new_h):
        for x in range(new_w):
            r, g, b, a = r_pixels[x, y]
            lum = 0.299 * r + 0.587 * g + 0.114 * b
            if has_alpha:
                is_fg = a > 120
            elif is_light_bg:
                is_fg = lum < cutoff
            else:
                is_fg = lum > cutoff

            if is_fg:
                fg_mask[y][x] = True
                box_min_x, box_max_x = min(box_min_x, x), max(box_max_x, x)
                box_min_y, box_max_y = min(box_min_y, y), max(box_max_y, y)

    if box_max_x == -1:
        return "██████"

    # 4. Render solid blocks █ with multi-stop gradient rotated along requested angle
    palette = GRADIENTS[int(gradient_index) % len(GRADIENTS)]
    lines = []

    for y in range(box_min_y, box_max_y + 1):
        line = []
        for x in range(box_min_x, box_max_x + 1):
            if not fg_mask[y][x]:
                line.append(" ")
            else:
                tx = (x - box_min_x) / max(1, box_max_x - box_min_x)
                ty = (y - box_min_y) / max(1, box_max_y - box_min_y)
                t = compute_gradient_t(tx, ty, angle)
                r, g, b = interpolate_palette(palette, t)
                line.append(f"\033[38;2;{r};{g};{b}m█\033[0m")
        lines.append("".join(line))

    # If a version tag is requested, append it formatted with matching ending gradient color
    if version_tag:
        last_r, last_g, last_b = palette[-1]
        pad = " " * 42
        lines.append(f"{pad}\033[38;2;{last_r};{last_g};{last_b}mv{version_tag}\033[0m")

    return "\n".join(lines)

def convert_to_ascii(file_path, max_width=None, max_height=None, gradient_index=0, version_tag=None, angle=None):
    if not os.path.exists(file_path):
        return ""
    _, ext = os.path.splitext(file_path.lower())
    if ext in [".txt", ".ascii", ".art", ".ans", ".nfo"]:
        return text_to_ascii_gradient(file_path, gradient_index, version_tag, angle)
    return image_to_ascii(file_path, max_width, max_height, gradient_index, version_tag, angle)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    file_path = sys.argv[1]
    w = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else None
    h = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[3].isdigit() else None
    grad_idx = int(float(sys.argv[4])) if len(sys.argv) > 4 and sys.argv[4].replace('.', '', 1).isdigit() else 0
    ver_tag = sys.argv[5] if len(sys.argv) > 5 and sys.argv[5] != "" else None
    angle = sys.argv[6] if len(sys.argv) > 6 else None

    print(convert_to_ascii(file_path, w, h, grad_idx, ver_tag, angle))
