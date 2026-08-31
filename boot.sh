#!/bin/bash

set -e

cat << 'EOF'
\033[38;2;168;85;247m                      ██          ██    ████\033[0m
\033[38;2;147;93;246m                      ██          ██    ████\033[0m
\033[38;2;126;101;246m ████ ██ ██ ██  ████  ██ ██ ██ ██ █████ ████\033[0m
\033[38;2;106;108;246m███████████████ █████ █████ ██ ██ █████ ████\033[0m
\033[38;2;85;116;246m██  ██ ██ ██ ██  █ ██ ████  ██ ██ ██ ██ ████\033[0m
\033[38;2;64;127;245m██  ██ █  ██ ██ █████ ████  ██ ██ ██ ██ ████\033[0m
\033[38;2;45;144;238m██  ██ █  ██ ██ ██ ██ ██ ██ ██ ██ ██ ██ ████\033[0m
\033[38;2;25;169;227m ████  █  ██ ██ ████████ ██ █████ █████ ████\033[0m
\033[38;2;6;182;212m                                        ████\033[0m
EOF

echo ""
echo "=> Omakub is for fresh Ubuntu 24.04+ / 26.04+ installations only!"
echo -e "\nBegin installation (or abort with ctrl+c)..."

sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

echo "Cloning Omakub..."
rm -rf ~/.local/share/omakub
OMAKUB_REPO="${OMAKUB_REPO:-https://github.com/nielsenchristoffer93/omakub.git}"
git clone "$OMAKUB_REPO" ~/.local/share/omakub >/dev/null
if [[ $OMAKUB_REF != "master" && -n "$OMAKUB_REF" ]]; then
	cd ~/.local/share/omakub
	git fetch origin "${OMAKUB_REF:-stable}" && git checkout "${OMAKUB_REF:-stable}"
	cd -
fi

echo "Installation starting..."
source ~/.local/share/omakub/install.sh
