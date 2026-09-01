#!/bin/bash

# VS Code and Antigravity IDE configuration targets
EDITOR_SETTINGS=(
  "$HOME/.config/Code/User/settings.json"
  "$HOME/.config/Antigravity/User/settings.json"
  "$HOME/.config/Antigravity IDE/User/settings.json"
  "$HOME/.config/antigravity/User/settings.json"
)

# Install theme extension in VS Code
if command -v code &>/dev/null; then
  code --install-extension "$VSC_EXTENSION" >/dev/null 2>&1 || true
  
  if [ -d "$HOME/.antigravity-ide" ] || [ -d "$HOME/.config/Antigravity IDE" ]; then
    mkdir -p "$HOME/.antigravity-ide/extensions"
    code --extensions-dir "$HOME/.antigravity-ide/extensions" --install-extension "$VSC_EXTENSION" >/dev/null 2>&1 || true
  fi
fi

# Sync installed theme extension to Antigravity IDE extension folder
if [ -d "$HOME/.vscode/extensions" ] && [ -d "$HOME/.antigravity-ide/extensions" ]; then
  cp -rn "$HOME/.vscode/extensions"/*"$VSC_EXTENSION"* "$HOME/.antigravity-ide/extensions/" 2>/dev/null || true
fi

# Apply theme across all detected editor settings.json files
for settings_file in "${EDITOR_SETTINGS[@]}"; do
  if [ -f "$settings_file" ]; then
    if grep -q "workbench.colorTheme" "$settings_file" 2>/dev/null; then
      sed -i "s/\"workbench.colorTheme\": \".*\"/\"workbench.colorTheme\": \"$VSC_THEME\"/g" "$settings_file"
    else
      sed -i "1s/^{/{\n  \"workbench.colorTheme\": \"$VSC_THEME\",/" "$settings_file" 2>/dev/null || true
    fi
  fi
done
