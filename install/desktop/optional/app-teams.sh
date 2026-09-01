#!/bin/bash

# Microsoft Teams Web Application https://teams.microsoft.com
source $OMAKUB_PATH/defaults/bash/functions

web2app 'Microsoft Teams' 'https://teams.microsoft.com' 'https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/microsoft-teams.png'
app2folder 'Microsoft Teams.desktop' Chat 2>/dev/null || true
