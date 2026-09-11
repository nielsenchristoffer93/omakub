# Omakub 2.0 ⚡

Turn a fresh Ubuntu installation into a fully-configured, beautiful, and modern developer workspace by running a single command.

Omakub is an opinionated, developer-first desktop setup built on Ubuntu. It provides a finely-tuned environment out of the box with modern terminal tooling, seamless tiling window management, curated color schemes, and workflow automations.

---

## 🚀 Quick Install

Run this command in a fresh installation of **Ubuntu 24.04+**:

```bash
wget -qO- https://raw.githubusercontent.com/nielsenchristoffer93/omakub/master/boot.sh | bash
```

> [!NOTE]
> Omakub is designed for fresh Ubuntu desktop installations. Back up any critical personal files before running on existing systems.

---

## ✨ Features & Highlights

### 🎨 Curated Themes & Editor Sync
Switch your entire desktop aesthetic across the OS, terminal, system monitor, and editors with a single command.

* **Available Themes**:
  * 🌆 **Cyberpunk** *(New in v2.0)*
  * 🕹️ **SynthWave '84** *(New in v2.0)*
  * 🌌 **Tokyo Night**
  * ☕ **Catppuccin**
  * ❄️ **Nord**
  * 🪵 **Gruvbox**
  * 🌲 **Everforest**
  * 🌸 **Rose Pine**
  * 🍵 **Osaka Jade**
  * ⬛ **Matte Black**
  * 🌊 **Kanagawa**
* **Editor Theme Synchronization**:
  * Seamlessly syncs themes and font sizes across **VS Code** and **Antigravity IDE**.
  * Instantly restyles **Neovim**, **Alacritty**, **Zellij**, **Btop**, and GNOME system accents.

### 💬 Modular Communication & Web Applications
No forced installations. All chat and web applications are strictly optional. Choose exactly which tools you want during initial setup or later via the Omakub menu:
* **Slack** (Native Snap)
* **Microsoft Teams** (PWA Web App)
* **Discord** (.deb desktop app)
* **Signal Desktop** (Official APT repository)
* **WhatsApp** (PWA Web App)
* **HEY** (Email & Calendar PWA Web App)
* **Basecamp** (Project Management PWA Web App)

### 🤖 Integrated AI Coding Agents (Antigravity & OpenCode)
Pre-configured with dedicated LazyVim plugins for both Google DeepMind's **Antigravity CLI** and [OpenCode](https://opencode.ai):
* **Antigravity CLI (`agy`)**: High-performance terminal coding agent with floating popup (<kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>a</kbd> / <kbd>g</kbd>) or right split sidebar (<kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>A</kbd>).
* **OpenCode Agent**: Multi-model terminal agent connecting Claude 3.7, GPT-4o, Gemini 2.5 Pro, DeepSeek R1, or local Ollama models with popup (<kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>o</kbd>), sidebar (<kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>s</kbd>), or bottom panel (<kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>b</kbd>).
* **Modular Neovim Specs**: Cleanly separated into `configs/neovim/antigravity.lua` and `configs/neovim/opencode.lua` with automatic buffer reloading (`autoread`).

### 📺 Interactive Terminal Screensaver
An eye-catching screensaver for your terminal powered by [`terminaltexteffects`](https://github.com/ChrisBuilds/terminaltexteffects):
* **Dynamic Multi-Stop Gradient ASCII Art**: Automatically converts images (`.png`, `.jpg`) or raw ASCII art (`.txt`, `.ascii`) with aspect-ratio preservation and rotating gradients (0°–360° and radial).
* **Over 30 Particle Animations**: Rain, beams, synthgrid, decrypt, blackhole, colorshift, and more running at 80fps.
* **Multi-Monitor Blackout**: Runs ASCII animation on your primary display while automatically blanking all secondary monitors.
* **Configurable**: Choose custom image/ASCII art, idle timeout (2m–30m), and optional desktop lock-on-wake.
* **Instant Start**: Launch via `omakub -> Screensaver` or search **Screensaver** in your application launcher.

### ⌨️ Omakub CLI & Quick Commands
Control your environment directly from the terminal:

```bash
# Launch interactive Omakub management menu
omakub

# Switch desktop & editor theme instantly
omakub theme cyberpunk
omakub theme synthwave-84
omakub theme tokyo-night

# Update system packages, flatpaks, snaps & Omakub in one step
omakub update

# Open the built-in keyboard shortcuts cheatsheet
omakub shortcuts
# or
omakub help
```

### 🔋 Laptop Battery Optimization (TLP)
Includes an optional **TLP** installation (`omakub -> Install -> TLP`) to optimize battery longevity, thermal throttling, and power profiles on Linux laptops.

---

## ⌨️ Essential Keyboard Shortcuts

Omakub configures sensible, ergonomic keybindings so your hands rarely have to leave the keyboard:

### 🪟 Windows & Tiling
| Shortcut | Action |
|---|---|
| <kbd>Super</kbd> + <kbd>T</kbd> | **Tactile Grid Tiling** (Press letters to place window, hold <kbd>Shift</kbd> to span cells) |
| <kbd>Super</kbd> + <kbd>W</kbd> | Close active window |
| <kbd>Super</kbd> + <kbd>Up</kbd> | Maximize / restore window |
| <kbd>Super</kbd> + <kbd>Left</kbd> / <kbd>Right</kbd> | Snap window to left / right half |
| <kbd>Super</kbd> + <kbd>Backspace</kbd> | Interactive window resize mode |
| <kbd>Shift</kbd> + <kbd>F11</kbd> | Toggle fullscreen with title bar |

### 🚀 App Launching & Dock
| Shortcut | Action |
|---|---|
| <kbd>Super</kbd> + <kbd>Space</kbd> | **Ulauncher** (Search apps, run calculations, lookup emojis) |
| <kbd>Alt</kbd> + <kbd>1</kbd> | Focus Google Chrome |
| <kbd>Alt</kbd> + <kbd>2</kbd> | Focus Alacritty Terminal |
| <kbd>Alt</kbd> + <kbd>3</kbd> | Focus Neovim |
| <kbd>Alt</kbd> + <kbd>4</kbd> | Focus VS Code / Antigravity IDE |
| <kbd>Alt</kbd> + <kbd>5</kbd>–<kbd>9</kbd> | Switch to pinned dock apps (Slack, Teams, etc.) |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>1</kbd> | Open **NEW** Chrome window |
| <kbd>Shift</kbd> + <kbd>Alt</kbd> + <kbd>2</kbd> | Open **NEW** Terminal window |

### 🧭 Workspaces
| Shortcut | Action |
|---|---|
| <kbd>Super</kbd> + <kbd>1</kbd>–<kbd>6</kbd> | Switch directly to Workspace 1 through 6 |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Up</kbd> / <kbd>Down</kbd> | Move active window to workspace above / below |
| <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd>–<kbd>6</kbd> | Move active window directly to specific workspace |

### ⌨️ Terminal & Zellij Multiplexer
| Shortcut | Action |
|---|---|
| <kbd>Ctrl</kbd> + <kbd>p</kbd> | **Pane Mode**: <kbd>n</kbd> = new split, <kbd>d</kbd> = split down, <kbd>r</kbd> = split right, <kbd>x</kbd> = close, <kbd>f</kbd> = zoom |
| <kbd>Ctrl</kbd> + <kbd>t</kbd> | **Tab Mode**: <kbd>n</kbd> = new tab, <kbd>x</kbd> = close tab, <kbd>1</kbd>–<kbd>9</kbd> = switch tab |
| <kbd>Ctrl</kbd> + <kbd>s</kbd> | **Scrollback & Search Mode** (Search terminal output history) |

### 🤖 AI Coding Agents in Neovim (LazyVim)
| Shortcut | Action |
|---|---|
| <kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>a</kbd> / <kbd>g</kbd> | Toggle **Antigravity AI Agent** (Floating popup) |
| <kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>A</kbd> | Toggle **Antigravity Sidebar** (Right split) |
| <kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>o</kbd> | Toggle **OpenCode AI Agent** (Floating popup) |
| <kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>s</kbd> | Toggle **OpenCode Sidebar** (Right split) |
| <kbd>&lt;leader&gt;</kbd> + <kbd>a</kbd> + <kbd>b</kbd> | Toggle **OpenCode Bottom Panel** (Bottom panel) |

### 📸 Screenshots & System
| Shortcut | Action |
|---|---|
| <kbd>Ctrl</kbd> + <kbd>Print</kbd> | **Flameshot** interactive screenshot editor |
| <kbd>Super</kbd> + <kbd>L</kbd> | Lock session |

*(Tip: Run `omakub shortcuts` anytime to view this reference directly in your terminal)*

---

## 🛠️ Software Stack

| Category | Tools |
|---|---|
| **Terminal & Shell** | Alacritty, Zellij, Bash, Starship Prompt, Gum, FZF, Ripgrep, Fastfetch |
| **Development** | Neovim, VS Code, Antigravity IDE & CLI (`agy`), OpenCode, Git, GitHub CLI, Docker, Dev Containers |
| **Productivity** | Google Chrome, Ulauncher, Flameshot, Btop, TLP |
| **Communication & Web** | Slack, Microsoft Teams, Discord, Signal, WhatsApp, HEY, Basecamp (All Optional) |
| **Extensions** | Tactile (Grid tiling), Space Bar (Workspace switcher), TopHat (System meters), Just Perfection |

---

## 📁 Repository Structure

```
~/.local/share/omakub/
├── bin/                 # CLI entry points and interactive Gum menus
│   ├── omakub           # Main CLI command
│   └── omakub-sub/      # Sub-menus (theme, font, screensaver, shortcuts, install)
├── configs/             # Configuration templates (alacritty, zellij, neovim, btop)
├── defaults/            # Default shell aliases, functions, and completions
├── install/             # Modular installers (desktop, terminal, chat apps, optional apps)
├── themes/              # Theme definitions (palettes, wallpapers, accent scripts)
└── uninstall/           # Corresponding uninstall scripts for all optional components
```

---

## 📜 License

Omakub is open-source software released under the [MIT License](LICENSE.md).
