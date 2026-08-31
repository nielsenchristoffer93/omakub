#!/bin/bash

# Obsidian is a multi-platform note taking application. See https://obsidian.md
cd /tmp
OBSIDIAN_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases | grep -o 'https://[^"]*amd64\.deb' | head -n 1)

if [ -n "$OBSIDIAN_URL" ]; then
  wget -qO obsidian.deb "$OBSIDIAN_URL"
  sudo apt install -y ./obsidian.deb
  rm -f obsidian.deb
else
  flatpak install -y flathub md.obsidian.Obsidian || sudo snap install obsidian --classic
fi
cd -
