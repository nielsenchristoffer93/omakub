#!/bin/bash

source "${OMAKUB_PATH:-$HOME/.local/share/omakub}/defaults/bash/functions"

rm -f "$HOME/.local/share/applications/HEY.desktop"
app2folder-remove 'HEY.desktop' WebApps 2>/dev/null || true
