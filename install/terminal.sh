#!/bin/bash

# Needed for all installers
sudo apt update -y
sudo apt upgrade -y
sudo apt install -y curl git unzip

# Run terminal installers
for installer in ${OMAKUB_PATH:-~/.local/share/omakub}/install/terminal/*.sh; do source $installer; done
