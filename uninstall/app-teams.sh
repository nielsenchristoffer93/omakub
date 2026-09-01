#!/bin/bash

source $OMAKUB_PATH/defaults/bash/functions 2>/dev/null || true
web2app-remove 'Microsoft Teams' 2>/dev/null || true
app2folder-remove 'Microsoft Teams.desktop' Chat 2>/dev/null || true
rm -f ~/.local/share/applications/'Microsoft Teams.desktop'
