#!/bin/bash

export OMAKUB_PATH="${OMAKUB_PATH:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
[ ! -d "$OMAKUB_PATH" ] && export OMAKUB_PATH="$HOME/.local/share/omakub"

CONVERTER="$OMAKUB_PATH/bin/omakub-sub/screensaver-converter.py"
OMAKUB_LOGO="$OMAKUB_PATH/applications/icons/omakub-logo.txt"

# Read version directly from the version file in Omakub root
VERSION="$(cat "$OMAKUB_PATH/version" 2>/dev/null | tr -d '[:space:]')"
[ -z "$VERSION" ] && [ -f "$(dirname "${BASH_SOURCE[0]}")/version" ] && VERSION="$(cat "$(dirname "${BASH_SOURCE[0]}")/version" 2>/dev/null | tr -d '[:space:]')"

# Shared dynamic gradient index and angle rotation
GRADIENT_INDEX="${OMAKUB_GRADIENT:-$((RANDOM % 6))}"
GRADIENT_ANGLE="${OMAKUB_GRADIENT_ANGLE:-random}"

if [ -f "$CONVERTER" ] && [ -f "$OMAKUB_LOGO" ]; then
  python3 "$CONVERTER" "$OMAKUB_LOGO" 54 9 "$GRADIENT_INDEX" "${VERSION:-2.0.0}" "$GRADIENT_ANGLE" 2>/dev/null
fi
