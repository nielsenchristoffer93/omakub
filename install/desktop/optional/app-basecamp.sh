#!/bin/bash

source "${OMAKUB_PATH:-$HOME/.local/share/omakub}/defaults/bash/functions"

mkdir -p "$HOME/.local/share/applications"

cat <<EOF >~/.local/share/applications/Basecamp.desktop
[Desktop Entry]
Version=1.0
Name=Basecamp
Comment=Basecamp Project Management
Exec=google-chrome --app="https://launchpad.37signals.com" --name=Basecamp --class=Basecamp
Terminal=false
Type=Application
Icon=${OMAKUB_PATH:-$HOME/.local/share/omakub}/applications/icons/Basecamp.png
Categories=GTK;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF

chmod +x "$HOME/.local/share/applications/Basecamp.desktop"
app2folder 'Basecamp.desktop' WebApps 2>/dev/null || true
