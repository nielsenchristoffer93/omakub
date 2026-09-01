#!/bin/bash

# OpenCode - The Open Source AI Coding Agent for the Terminal (https://opencode.ai)
# Model-agnostic terminal agent supporting Claude, GPT-4o, Gemini, DeepSeek, Ollama & more
curl -fsSL https://opencode.ai/install | bash

# Ensure Neovim plugin configuration is present if Neovim is configured
if [ -d "$HOME/.config/nvim/lua/plugins" ]; then
  cp "${OMAKUB_PATH:-$HOME/.local/share/omakub}/configs/neovim/opencode.lua" "$HOME/.config/nvim/lua/plugins/opencode.lua"
fi
