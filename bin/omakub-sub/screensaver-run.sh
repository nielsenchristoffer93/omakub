#!/bin/bash

CONFIG_DIR="$HOME/.config/omakub/screensaver"
OMAKUB_DIR="${OMAKUB_PATH:-$HOME/.local/share/omakub}"

# Resolve image path (default: screensaver-logo.jpeg)
IMAGE_PATH=""
if [ -n "$1" ] && [ -f "$1" ]; then
  IMAGE_PATH="$1"
elif [ -f "$CONFIG_DIR/image_path" ]; then
  SAVED_PATH=$(cat "$CONFIG_DIR/image_path")
  [ -f "$SAVED_PATH" ] && IMAGE_PATH="$SAVED_PATH"
fi

if [ -z "$IMAGE_PATH" ] || [ ! -f "$IMAGE_PATH" ]; then
  IMAGE_PATH="$OMAKUB_DIR/applications/icons/screensaver-logo.jpeg"
  [ ! -f "$IMAGE_PATH" ] && IMAGE_PATH="$OMAKUB_DIR/applications/icons/Omakub.png"
fi

# Ensure tte is available
if ! command -v tte &>/dev/null; then
  pipx install terminaltexteffects >/dev/null 2>&1
  pipx runpip terminaltexteffects install pillow >/dev/null 2>&1
fi

CONVERTER="$OMAKUB_DIR/bin/omakub-sub/screensaver-converter.py"
[ ! -f "$CONVERTER" ] && CONVERTER="$(dirname "$0")/screensaver-converter.py"

EFFECTS=(
  "beams" "binarypath" "blackhole" "bouncyballs" "bubbles"
  "burn" "colorshift" "crumble" "decrypt" "errorcorrect"
  "expand" "fireworks" "highlight" "laseretch" "matrix"
  "middleout" "orbittingvolley" "overflow" "pour" "print"
  "rain" "randomsequence" "rings" "scattered" "slice"
  "slide" "smoke" "spotlights" "spray" "swarm"
  "sweep" "synthgrid" "thunderstorm" "unstable" "vhstape"
  "waves" "wipe"
)

# Restore terminal on exit
ORIG_STTY=$(stty -g 2>/dev/null || true)

cleanup() {
  [ -n "$KEY_PID" ] && kill -TERM "$KEY_PID" 2>/dev/null || true
  pkill -P $$ 2>/dev/null || true
  tput cnorm 2>/dev/null || true
  [ -n "$ORIG_STTY" ] && stty "$ORIG_STTY" 2>/dev/null || true
  clear
  exit 0
}
trap cleanup INT TERM EXIT

# Background key listener: instantly exits on ANY keypress even while tte animates
(
  while true; do
    if read -n 1 -s key 2>/dev/null; then
      kill -TERM $$ 2>/dev/null
      exit 0
    fi
  done
) &
KEY_PID=$!

tput civis 2>/dev/null || true
clear

LAST_EFFECT=""
GRADIENT_INDEX=0

while true; do
  tput civis 2>/dev/null || true

  COLS=$(tput cols 2>/dev/null || echo 80)
  LINES=$(tput lines 2>/dev/null || echo 24)
  MAX_W=$((COLS * 36 / 100))
  [ "$MAX_W" -gt 54 ] && MAX_W=54
  [ "$MAX_W" -lt 36 ] && MAX_W=36

  MAX_H=$((LINES * 20 / 100))
  [ "$MAX_H" -gt 9 ] && MAX_H=9
  [ "$MAX_H" -lt 6 ] && MAX_H=6

  # Generate ASCII Art using solid Omarchy blocks █ with multi-color gradient
  ASCII_ART=$(python3 "$CONVERTER" "$IMAGE_PATH" "$MAX_W" "$MAX_H" "$GRADIENT_INDEX" 2>/dev/null)
  [ -z "$ASCII_ART" ] && ASCII_ART="██████"

  GRADIENT_INDEX=$((GRADIENT_INDEX + 1))

  # Pick random effect
  while true; do
    EFFECT="${EFFECTS[$((RANDOM % ${#EFFECTS[@]}))]}"
    [ "$EFFECT" != "$LAST_EFFECT" ] && { LAST_EFFECT="$EFFECT"; break; }
  done

  # Run animation
  echo "$ASCII_ART" | tte \
    --existing-color-handling always \
    --canvas-width 0 \
    --canvas-height 0 \
    --anchor-canvas c \
    --anchor-text c \
    --no-eol \
    --no-restore-cursor \
    "$EFFECT" 2>/dev/null || true

  tput civis 2>/dev/null || true

  # Hold result for 3 seconds between effects
  sleep 3 &
  wait $! 2>/dev/null || true

  clear
done
