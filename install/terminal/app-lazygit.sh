#!/bin/bash

cd /tmp
LAZYGIT_VERSION=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/jesseduffield/lazygit/releases/latest" | rev | cut -d'/' -f1 | rev | sed 's/^v//')
LAZYGIT_VERSION="${LAZYGIT_VERSION:-0.64.1}"
curl -sLo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit
mkdir -p ~/.config/lazygit/
touch ~/.config/lazygit/config.yml
cd -
