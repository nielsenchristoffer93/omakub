#!/bin/bash

# Uninstall OpenCode CLI
rm -rf "$HOME/.opencode" "$HOME/.local/bin/opencode"
rm -f "$HOME/.config/nvim/lua/plugins/opencode.lua"
