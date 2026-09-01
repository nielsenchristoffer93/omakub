#!/bin/bash

set -e

echo -e "\033[38;2;168;85;247m ▄██████▄    ▄▄▄▄███▄▄▄▄      ▄████████    ▄█   ▄█▄ ███    █▄  ▀█████████▄ \033[0m"
echo -e "\033[38;2;148;88;247m███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███   ███ ▄███▀ ███    ███   ███    ███\033[0m"
echo -e "\033[38;2;128;95;246m███    ███ ███   ███   ███   ███    ███   ███▐██▀   ███    ███   ███    ███\033[0m"
echo -e "\033[38;2;108;102;246m███    ███ ███   ███   ███   ███    ███  ▄█████▀    ███    ███  ▄███▄▄▄██▀ \033[0m"
echo -e "\033[38;2;88;108;246m███    ███ ███   ███   ███ ▀███████████ ▀▀█████▄    ███    ███ ▀▀███▀▀▀██▄ \033[0m"
echo -e "\033[38;2;68;115;246m███    ███ ███   ███   ███   ███    ███   ███▐██▄   ███    ███   ███    ██▄\033[0m"
echo -e "\033[38;2;48;128;238m███    ███ ███   ███   ███   ███    ███   ███ ▀███▄ ███    ███   ███    ███\033[0m"
echo -e "\033[38;2;28;152;229m ▀██████▀   ▀█   ███   █▀    ███    █▀    ███   ▀█▀ ████████▀  ▄█████████▀ \033[0m"
echo -e "\033[38;2;6;182;212m                                          ▀                                \033[0m"

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
