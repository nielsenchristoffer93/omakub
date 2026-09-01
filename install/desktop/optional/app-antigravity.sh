#!/bin/bash

# Antigravity is Google DeepMind's AI Coding Assistant and IDE
sudo snap install antigravity --classic

for target_dir in "$HOME/.config/Antigravity/User" "$HOME/.config/Antigravity IDE/User"; do
  if [ ! -f "$target_dir/settings.json" ]; then
    mkdir -p "$target_dir"
    cp "$OMAKUB_PATH/configs/vscode.json" "$target_dir/settings.json" 2>/dev/null || true
  fi
done
