#!/bin/bash

cat <<EOF >~/.local/share/applications/Screensaver.desktop
[Desktop Entry]
Version=1.0
Name=Screensaver
Comment=Omakub ASCII Screensaver
Exec=alacritty --config-file /home/$USER/.config/alacritty/screensaver.toml --class=OmakubScreensaver --title="Omakub Screensaver" -e bash -c "source /home/$USER/.local/share/omakub/bin/omakub-sub/screensaver-run.sh"
Terminal=false
Type=Application
Icon=/home/$USER/.local/share/omakub/applications/icons/Omakub.png
Categories=Utility;
Keywords=screensaver;animation;omakub;ascii;
StartupNotify=false
EOF
