#!/bin/bash

show_category() {
  local title="$1"
  local content="$2"

  clear
  source $OMAKUB_PATH/bin/omakub-sub/header.sh

  gum style \
    --border normal \
    --border-foreground 212 \
    --padding "1 2" \
    --margin "1 2" \
    --align left \
    "$title" "$content"

  echo ""
  gum style --foreground 240 --align center "Press any key to return..."
  read -n 1 -s
}

while true; do
  CHOICE=$(gum choose \
    "🪟  Window Management & Tiling" \
    "🚀  App Launching & Dock" \
    "🧭  Workspaces & Navigation" \
    "🤖  OpenCode AI in Neovim" \
    "⌨️   Terminal & Zellij Shortcuts" \
    "📸  Screenshots & System Controls" \
    "🛠️   Omakub CLI Commands" \
    "📋  View All Shortcuts (Cheatsheet)" \
    "🌐  Open Online Web Manual" \
    "<< Back" \
    --height 14 \
    --header "Omakub Keyboard Shortcuts & Help")

  case "$CHOICE" in
  "🪟  Window Management & Tiling"*)
    show_category "🪟 WINDOW MANAGEMENT & TILING" \
"• Super + T           Activate Tactile Grid Tiling
                       (Press letter keys to snap window into grid cells)
                       (Hold Shift + letters to span multiple grid cells)
• Super + W           Close active window
• Super + Up          Maximize / unmaximize window
• Super + Left/Right  Snap window left/right half
• Super + Backspace   Interactive window resize mode
• Shift + F11         Toggle fullscreen with title bar
• F11                 Toggle fullscreen (Terminal / Alacritty)"
    ;;

  "🚀  App Launching & Dock"*)
    show_category "🚀 APP LAUNCHING & DOCK" \
"• Super + Space       Ulauncher (Quick search, apps, math, emojis)
• Alt + 1             Google Chrome
• Alt + 2             Alacritty Terminal
• Alt + 3             Neovim
• Alt + 4             VS Code / Antigravity IDE
• Alt + 5..9          Pinned Dock apps (WhatsApp, Signal, Slack, etc.)
• Shift + Alt + 1     Open NEW Google Chrome window
• Shift + Alt + 2     Open NEW Alacritty Terminal window"
    ;;

  "🧭  Workspaces & Navigation"*)
    show_category "🧭 WORKSPACES & NAVIGATION" \
"• Super + 1..6        Switch directly to Workspace 1, 2, 3, 4, 5, or 6
• Super + Shift + Up   Move active window to workspace above
• Super + Shift + Down Move active window to workspace below
• Super + Shift + 1..6 Move active window to specific workspace"
    ;;

  "🤖  OpenCode AI in Neovim"*)
    show_category "🤖 OPENCODE AI IN NEOVIM (LAZYVIM)" \
"• <leader>ao          Toggle OpenCode AI Agent (Floating popup)
• <leader>as          Toggle OpenCode AI Agent (Right sidebar)
• <leader>aa          Toggle OpenCode AI Agent (Bottom panel)
• Autoread            Buffers reload automatically when OpenCode edits files"
    ;;

  "⌨️   Terminal & Zellij Shortcuts"*)
    show_category "⌨️ TERMINAL & ZELLIJ SHORTCUTS" \
"• Ctrl + p            Zellij PANE mode:
                       • n = New pane (auto split)
                       • d = New pane split DOWN
                       • r = New pane split RIGHT
                       • x = Close current pane
                       • f = Toggle pane fullscreen / zoom
• Ctrl + t            Zellij TAB mode:
                       • n = New tab
                       • x = Close tab
                       • 1..9 = Switch to tab 1..9
• Ctrl + s            Zellij SCROLL / Search mode (search scrollback history)
• Ctrl + q            Detach from Zellij session"
    ;;

  "📸  Screenshots & System Controls"*)
    show_category "📸 SCREENSHOTS & SYSTEM CONTROLS" \
"• Ctrl + PrintScreen  Flameshot GUI interactive screenshot
• Super + L            Lock computer session (GNOME Secure Lock)
• Ctrl + F1 / F2       Apple Studio Display brightness down / up (ASDControl)
• Shift + AudioPlay    Next track (Logitech MX Keys / media keys)"
    ;;

  "🛠️   Omakub CLI Commands"*)
    show_category "🛠️ OMAKUB CLI COMMANDS" \
"• omakub                     Open interactive Omakub menu
• omakub theme <name>        Switch theme instantly (e.g. omakub theme cyberpunk)
• omakub update              Update system packages, flatpaks, snaps & Omakub
• omakub help / shortcuts    Show this shortcuts cheatsheet directly"
    ;;

  "📋  View All Shortcuts (Cheatsheet)"*)
    clear
    source $OMAKUB_PATH/bin/omakub-sub/header.sh

    ALL_CONTENT="# 🪟 WINDOWS & TILING
Super + T           Activate Tactile grid tiling (press keys to snap)
Super + W           Close active window
Super + Up          Maximize window
Super + Left/Right  Snap window left/right
Super + Backspace   Resize window mode
Shift + F11         Fullscreen mode

# 🚀 APPS & DOCK
Super + Space       Ulauncher app search & calculator
Alt + 1..9          Switch to dock app 1..9
Shift + Alt + 1     Open NEW Chrome window
Shift + Alt + 2     Open NEW Alacritty window

# 🤖 OPENCODE AI (LazyVim)
<leader>ao          Toggle OpenCode (Floating popup)
<leader>as          Toggle OpenCode (Right sidebar)
<leader>aa          Toggle OpenCode (Bottom panel)

# 🧭 WORKSPACES
Super + 1..6        Switch to workspace 1..6
Super + Shift + 1..6 Move window to workspace 1..6

# ⌨️ ZELLIJ TERMINAL
Ctrl + p            Pane mode (n: new, d: down, r: right, x: close, f: zoom)
Ctrl + t            Tab mode (n: new tab, x: close, 1..9: switch tab)
Ctrl + s            Scrollback & search mode

# 📸 SYSTEM & TOOLS
Ctrl + PrintScreen  Flameshot screenshot tool
Super + L           Lock computer session
omakub theme <name> Switch theme instantly
omakub update       Update all packages & tools"

    gum style \
      --border normal \
      --border-foreground 212 \
      --padding "1 2" \
      --margin "1 1" \
      "$ALL_CONTENT"

    echo ""
    gum style --foreground 240 --align center "Press any key to return..."
    read -n 1 -s
    ;;

  "🌐  Open Online Web Manual"*)
    xdg-open "https://manual.omakub.org" &>/dev/null || true
    ;;

  "<< Back"* | "")
    break
    ;;
  esac
done

clear
source $OMAKUB_PATH/bin/omakub-sub/menu.sh
