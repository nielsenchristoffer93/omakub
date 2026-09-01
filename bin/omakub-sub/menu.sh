#!/bin/bash

if [ $# -eq 0 ]; then
	SUB=$(gum choose "Theme" "Font" "Screensaver" "Shortcuts" "Update" "Install" "Uninstall" "Manual" "Quit" --height 12 --header "" | tr '[:upper:]' '[:lower:]')
else
	SUB=$1
fi

[ -n "$SUB" ] && [ "$SUB" != "quit" ] && source $OMAKUB_PATH/bin/omakub-sub/$SUB.sh
