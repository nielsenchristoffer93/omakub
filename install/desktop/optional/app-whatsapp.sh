#!/bin/bash

# WhatsApp Web Application
source $OMAKUB_PATH/defaults/bash/functions

web2app 'WhatsApp' 'https://web.whatsapp.com' 'https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/whatsapp.png'
app2folder 'WhatsApp.desktop' Chat 2>/dev/null || true
