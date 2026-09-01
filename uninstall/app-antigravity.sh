#!/bin/bash

# Uninstall Antigravity CLI & data
rm -rf "$HOME/.local/bin/agy" "$HOME/.antigravity"
rm -f "$HOME/.config/nvim/lua/plugins/antigravity.lua"
