#!/bin/bash

CONFIG_DIR="$HOME/.config/omakub/screensaver"
mkdir -p "$CONFIG_DIR"
OMAKUB_DIR="${OMAKUB_PATH:-$HOME/.local/share/omakub}"

CONVERTER="$OMAKUB_DIR/bin/omakub-sub/screensaver-converter.py"
[ ! -f "$CONVERTER" ] && CONVERTER="$(dirname "$0")/screensaver-converter.py"

RUNNER="$OMAKUB_DIR/bin/omakub-sub/screensaver-run.sh"
[ ! -f "$RUNNER" ] && RUNNER="$(dirname "$0")/screensaver-run.sh"

ALACRITTY_CONF="$HOME/.config/alacritty/screensaver.toml"
[ ! -f "$ALACRITTY_CONF" ] && ALACRITTY_CONF="$OMAKUB_DIR/configs/alacritty/screensaver.toml"

# Resolve current image name for display
CURRENT_IMG="Default (Omakub)"
if [ -f "$CONFIG_DIR/image_path" ]; then
  SAVED_PATH=$(cat "$CONFIG_DIR/image_path")
  [ -f "$SAVED_PATH" ] && CURRENT_IMG="$(basename "$SAVED_PATH")"
fi

# Resolve idle timeout label
IDLE_LABEL="5m"
if [ -f "$CONFIG_DIR/idle_timeout" ]; then
  SEC=$(cat "$CONFIG_DIR/idle_timeout" 2>/dev/null)
  if [ "$SEC" = "0" ]; then
    IDLE_LABEL="Off"
  elif [ -n "$SEC" ]; then
    MIN=$((SEC / 60))
    IDLE_LABEL="${MIN}m"
  fi
fi

# Resolve lock on wake label
LOCK_LABEL="No"
if [ -f "$CONFIG_DIR/lock_on_wake" ] && [ "$(cat "$CONFIG_DIR/lock_on_wake" 2>/dev/null)" = "true" ]; then
  LOCK_LABEL="Yes"
fi

show_preview() {
  clear
  COLS=$(tput cols 2>/dev/null || echo 80)
  LINES=$(tput lines 2>/dev/null || echo 24)
  MAX_W=$((COLS * 60 / 100))
  [ "$MAX_W" -gt 68 ] && MAX_W=68
  [ "$MAX_W" -lt 36 ] && MAX_W=36

  MAX_H=$((LINES * 55 / 100))
  [ "$MAX_H" -gt 22 ] && MAX_H=22
  [ "$MAX_H" -lt 8 ] && MAX_H=8

  IMG="$OMAKUB_DIR/applications/icons/screensaver-logo.txt"
  [ ! -f "$IMG" ] && IMG="$OMAKUB_DIR/applications/icons/logo.txt"
  [ ! -f "$IMG" ] && IMG="$OMAKUB_DIR/applications/icons/screensaver-logo.jpeg"
  [ ! -f "$IMG" ] && IMG="$OMAKUB_DIR/applications/icons/Omakub.png"
  if [ -f "$CONFIG_DIR/image_path" ]; then
    SAVED_PATH=$(cat "$CONFIG_DIR/image_path")
    [ -f "$SAVED_PATH" ] && IMG="$SAVED_PATH"
  fi

  ASCII_ART=$(python3 "$CONVERTER" "$IMG" "$MAX_W" "$MAX_H" 0 2>/dev/null)
  ART_LINES=$(echo "$ASCII_ART" | wc -l)
  PAD_TOP=$(( (LINES - ART_LINES - 4) / 2 ))
  [ "$PAD_TOP" -lt 1 ] && PAD_TOP=1

  for ((i=0; i<PAD_TOP; i++)); do echo ""; done

  while IFS= read -r line; do
    RAW_LINE=$(echo "$line" | sed -r 's/\x1B\[[0-9;]*[a-zA-Z]//g')
    LINE_W=${#RAW_LINE}
    PAD_LEFT=$(( (COLS - LINE_W) / 2 ))
    [ "$PAD_LEFT" -lt 0 ] && PAD_LEFT=0
    printf "%*s%s\n" "$PAD_LEFT" "" "$line"
  done <<< "$ASCII_ART"

  echo ""
  gum style --foreground 240 --align center --width "$COLS" "Logo: $(basename "$IMG")  •  Press any key to return..."
  read -n 1 -s
}

CHOICES=(
  "Start Screensaver"
  "Preview Logo"
  "Choose Custom Logo (Image / ASCII)"
  "Set Idle Timeout (Current: $IDLE_LABEL)"
  "Lock Screen on Wake (Current: $LOCK_LABEL)"
  "Reset to Default Logo"
  "<< Back"
)

CHOICE=$(gum choose "${CHOICES[@]}" --header "Omakub Screensaver (Current: $CURRENT_IMG)" --height 11)

if [[ "$CHOICE" == "<< Back"* ]] || [[ -z "$CHOICE" ]]; then
  # Return to main menu
  :
elif [ "$CHOICE" = "Start Screensaver" ]; then
  alacritty \
    --config-file "$ALACRITTY_CONF" \
    --class OmakubScreensaver,OmakubScreensaver \
    --title "Omakub Screensaver" \
    -e bash -c "source '$RUNNER'"
elif [ "$CHOICE" = "Preview Logo" ]; then
  show_preview
elif [[ "$CHOICE" == "Choose Custom Logo"* ]] || [ "$CHOICE" = "Choose Custom Image" ]; then
  current_dir="$HOME"
  [ -d "$HOME/Pictures" ] && current_dir="$HOME/Pictures"

  while true; do
    items=()
    [ "$current_dir" != "$HOME" ] && [ "$current_dir" != "/" ] && items+=(".. (Go up)")

    for d in "$current_dir"/*; do
      if [ -d "$d" ] && [ ! -L "$d" ]; then
        base=$(basename "$d")
        [[ "$base" != .* ]] && items+=("📁 $base/")
      fi
    done

    for f in "$current_dir"/*; do
      if [ -f "$f" ]; then
        base=$(basename "$f")
        if [[ "$base" =~ \.(png|jpg|jpeg|webp|svg|bmp|gif|PNG|JPG|JPEG|WEBP|SVG|BMP|GIF)$ ]]; then
          items+=("🖼️  $base")
        elif [[ "$base" =~ \.(txt|ascii|art|ans|nfo|TXT|ASCII|ART|ANS|NFO)$ ]]; then
          items+=("📄  $base")
        fi
      fi
    done

    items+=("🔍 Search with FZF" "<< Cancel")

    file_choice=$(gum choose "${items[@]}" --header "Folder: $current_dir (Press Enter to open/select)" --height 16)

    if [ "$file_choice" = "<< Cancel" ] || [ -z "$file_choice" ]; then
      break
    elif [ "$file_choice" = ".. (Go up)" ]; then
      current_dir=$(dirname "$current_dir")
    elif [ "$file_choice" = "🔍 Search with FZF" ]; then
      selected_fzf=$(find "$HOME" -maxdepth 4 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.svg" -o -iname "*.txt" -o -iname "*.ascii" -o -iname "*.art" \) 2>/dev/null | fzf --header="Type to filter images & ASCII files (Enter to select, Esc to cancel)")
      if [ -n "$selected_fzf" ] && [ -f "$selected_fzf" ]; then
        echo "$selected_fzf" > "$CONFIG_DIR/image_path"
        show_preview
        break
      fi
    elif [[ "$file_choice" == 📁* ]]; then
      folder_name="${file_choice#📁 }"
      folder_name="${folder_name%/}"
      current_dir="$current_dir/$folder_name"
    elif [[ "$file_choice" == 🖼️* ]] || [[ "$file_choice" == 📄* ]]; then
      file_name="${file_choice:4}"
      echo "$current_dir/$file_name" > "$CONFIG_DIR/image_path"
      show_preview
      break
    fi
  done
elif [[ "$CHOICE" == "Set Idle Timeout"* ]]; then
  TIMEOUT_CHOICE=$(gum choose \
    "2 Minutes" \
    "5 Minutes (Default)" \
    "10 Minutes" \
    "15 Minutes" \
    "30 Minutes" \
    "Disabled (Off)" \
    "<< Back" \
    --header "Auto-start screensaver after inactivity:" --height 10)

  case "$TIMEOUT_CHOICE" in
    "2 Minutes")
      echo "120" > "$CONFIG_DIR/idle_timeout"
      gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true
      ;;
    "5 Minutes"*)
      echo "300" > "$CONFIG_DIR/idle_timeout"
      gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true
      ;;
    "10 Minutes")
      echo "600" > "$CONFIG_DIR/idle_timeout"
      gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true
      ;;
    "15 Minutes")
      echo "900" > "$CONFIG_DIR/idle_timeout"
      gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true
      ;;
    "30 Minutes")
      echo "1800" > "$CONFIG_DIR/idle_timeout"
      gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true
      ;;
    "Disabled (Off)")
      echo "0" > "$CONFIG_DIR/idle_timeout"
      gsettings set org.gnome.desktop.session idle-delay 300 2>/dev/null || true
      ;;
  esac

  systemctl --user restart omakub-screensaver.service 2>/dev/null || true
elif [[ "$CHOICE" == "Lock Screen on Wake"* ]]; then
  LOCK_CHOICE=$(gum choose \
    "Yes (Require password to unlock)" \
    "No (Return directly to desktop)" \
    "<< Back" \
    --header "Lock screen when waking up from screensaver?" --height 7)

  case "$LOCK_CHOICE" in
    "Yes"*) echo "true" > "$CONFIG_DIR/lock_on_wake" ;;
    "No"*) echo "false" > "$CONFIG_DIR/lock_on_wake" ;;
  esac
elif [ "$CHOICE" = "Reset to Default Logo" ]; then
  rm -f "$CONFIG_DIR/image_path"
fi

clear
source $OMAKUB_DIR/bin/omakub
