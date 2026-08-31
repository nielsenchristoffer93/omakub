#!/bin/bash

cd /tmp
LAZYDOCKER_VERSION=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/jesseduffield/lazydocker/releases/latest" | rev | cut -d'/' -f1 | rev | sed 's/^v//')
LAZYDOCKER_VERSION="${LAZYDOCKER_VERSION:-0.25.2}"
curl -sLo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin
rm lazydocker.tar.gz lazydocker
cd -
