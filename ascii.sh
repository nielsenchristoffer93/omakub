#!/bin/bash

export OMAKUB_PATH="${OMAKUB_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
[ ! -d "$OMAKUB_PATH" ] && export OMAKUB_PATH="$HOME/.local/share/omakub"

CONVERTER="$OMAKUB_PATH/bin/omakub-sub/screensaver-converter.py"
LOGO_IMG="$OMAKUB_PATH/applications/icons/screensaver-logo.jpeg"
[ ! -f "$LOGO_IMG" ] && LOGO_IMG="$OMAKUB_PATH/applications/icons/Omakub.png"

# Read version directly from the version file in Omakub root
VERSION="$(cat "$OMAKUB_PATH/version" 2>/dev/null | tr -d '[:space:]')"
[ -z "$VERSION" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/version" ] && VERSION="$(cat "$(dirname "${BASH_SOURCE[0]}")/version" 2>/dev/null | tr -d '[:space:]')"

# Shared dynamic gradient index (picks random palette or uses OMAKUB_GRADIENT)
GRADIENT_INDEX="${OMAKUB_GRADIENT:-$((RANDOM % 6))}"

if [ -f "$CONVERTER" ] && [ -f "$LOGO_IMG" ]; then
  python3 "$CONVERTER" "$LOGO_IMG" 54 9 "$GRADIENT_INDEX" "${VERSION:-2.0.0}" 2>/dev/null
fi
