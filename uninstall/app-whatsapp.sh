#!/bin/bash

source $OMAKUB_PATH/defaults/bash/functions 2>/dev/null || true
web2app-remove 'WhatsApp' 2>/dev/null || true
app2folder-remove 'WhatsApp.desktop' Chat 2>/dev/null || true
rm -f ~/.local/share/applications/WhatsApp.desktop
