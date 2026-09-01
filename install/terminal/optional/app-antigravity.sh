#!/bin/bash

# Antigravity CLI - Google DeepMind AI Coding Assistant for Terminal (https://antigravity.google)
curl -fsSL https://antigravity.google/cli/install.sh | bash

# Ensure Neovim plugin configuration is present if Neovim is configured
if [ -d "$HOME/.config/nvim/lua/plugins" ]; then
  cp "${OMAKUB_PATH:-$HOME/.local/share/omakub}/configs/neovim/antigravity.lua" "$HOME/.config/nvim/lua/plugins/antigravity.lua"
fi
