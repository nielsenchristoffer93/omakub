#!/bin/bash

# Gum is used for the Omakub commands for tailoring Omakub after the initial install
cd /tmp
GUM_VERSION=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/charmbracelet/gum/releases/latest" | rev | cut -d'/' -f1 | rev | sed 's/^v//')
GUM_VERSION="${GUM_VERSION:-2.0.0}"
wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_amd64.deb"
sudo apt-get install -y --allow-downgrades ./gum.deb
rm gum.deb
cd -
