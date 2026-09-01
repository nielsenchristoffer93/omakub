#!/bin/bash

source "${OMAKUB_PATH:-$HOME/.local/share/omakub}/defaults/bash/functions"

rm -f "$HOME/.local/share/applications/Basecamp.desktop"
app2folder-remove 'Basecamp.desktop' WebApps 2>/dev/null || true
