#!/bin/bash

cd /tmp
LOCALSEND_VERSION=$(curl -sL -o /dev/null -w '%{url_effective}' "https://github.com/localsend/localsend/releases/latest" | rev | cut -d'/' -f1 | rev | sed 's/^v//')
LOCALSEND_VERSION="${LOCALSEND_VERSION:-1.18.2}"
wget -qO localsend.deb "https://github.com/localsend/localsend/releases/download/v${LOCALSEND_VERSION}/LocalSend-${LOCALSEND_VERSION}-linux-x86-64.deb"
sudo apt install -y ./localsend.deb
rm localsend.deb
cd -
