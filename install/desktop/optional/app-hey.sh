#!/bin/bash

source "${OMAKUB_PATH:-$HOME/.local/share/omakub}/defaults/bash/functions"

mkdir -p "$HOME/.local/share/applications"

cat <<EOF >~/.local/share/applications/HEY.desktop
[Desktop Entry]
Version=1.0
Name=HEY
Comment=HEY Email + Calendar
Exec=google-chrome --app="https://app.hey.com/" --name=HEY --class=HEY
Terminal=false
Type=Application
Icon=${OMAKUB_PATH:-$HOME/.local/share/omakub}/applications/icons/HEY.png
Categories=GTK;
MimeType=text/html;text/xml;application/xhtml_xml;
StartupNotify=true
EOF

chmod +x "$HOME/.local/share/applications/HEY.desktop"
app2folder 'HEY.desktop' WebApps 2>/dev/null || true
