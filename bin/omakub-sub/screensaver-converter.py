#!/usr/bin/env python3
import sys
import os
import shutil

try:
    from PIL import Image
except ImportError:
    venv_site = os.path.expanduser("~/.local/share/pipx/venvs/terminaltexteffects/lib")
    if os.path.isdir(venv_site):
        for root, dirs, files in os.walk(venv_site):
            if "site-packages" in dirs:
                sys.path.append(os.path.join(root, "site-packages"))
                break
    from PIL import Image

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

def image_to_ascii(image_path, max_width=None, max_height=None, gradient_index=0, version_tag=None):
    if not os.path.isfile(image_path):
        return ""

    term_size = shutil.get_terminal_size((80, 24))
    explicit_w = max_width is not None
    explicit_h = max_height is not None

    max_width = max(10, max_width or int(term_size.columns * 0.55))
    max_height = max(5, max_height or int(term_size.lines * 0.45))

    img = Image.open(image_path).convert("RGBA")
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

    # 2. Compact aspect ratio scaling (Terminal characters are ~1:2 height/width ratio)
    cw, ch = img.size
    if explicit_w and explicit_h:
        new_w = max_width
        new_h = max_height
    else:
        aspect = (ch / cw) * 1.10
        new_h = min(max_height, max(5, int(max_width * aspect)))
        new_w = min(max_width, max(10, int(new_h / aspect)))

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

    # 4. Render solid blocks █ with multi-stop gradient
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
                t = tx * 0.35 + ty * 0.65
                r, g, b = interpolate_palette(palette, t)
                line.append(f"\033[38;2;{r};{g};{b}m█\033[0m")
        lines.append("".join(line))

    # If a version tag is requested, append it formatted with matching ending gradient color
    if version_tag:
        last_r, last_g, last_b = palette[-1]
        pad = " " * 42
        lines.append(f"{pad}\033[38;2;{last_r};{last_g};{last_b}mv{version_tag}\033[0m")

    return "\n".join(lines)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        sys.exit(1)

    img_path = sys.argv[1]
    w = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else None
    h = int(sys.argv[3]) if len(sys.argv) > 3 and sys.argv[3].isdigit() else None
    grad_idx = int(float(sys.argv[4])) if len(sys.argv) > 4 and sys.argv[4].replace('.', '', 1).isdigit() else 0
    ver_tag = sys.argv[5] if len(sys.argv) > 5 else None

    print(image_to_ascii(img_path, w, h, grad_idx, ver_tag))
