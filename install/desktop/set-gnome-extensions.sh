#!/bin/bash

sudo apt install -y gnome-shell-extension-manager gir1.2-gtop-2.0 gir1.2-clutter-1.0 lm-sensors
pipx install gnome-extensions-cli --system-site-packages

# Turn off default Ubuntu extensions
gnome-extensions disable tiling-assistant@ubuntu.com
gnome-extensions disable ubuntu-appindicators@ubuntu.com
gnome-extensions disable ubuntu-dock@ubuntu.com
gnome-extensions disable ding@rastersoft.com

# Pause to assure user is ready to accept confirmations
gum confirm "To install Gnome extensions, you need to accept some confirmations. Ready?"

# Ensure ~/.local/bin is in PATH for gext
export PATH="$HOME/.local/bin:$PATH"

# Install new extensions safely
EXTENSIONS=(
  "tactile@lundal.io"
  "just-perfection-desktop@just-perfection"
  "blur-my-shell@aunetx"
  "space-bar@luchrioh"
  "undecorate@sun.wxg@gmail.com"
  "tophat@fflewddur.github.io"
  "AlphabeticalAppGrid@stuarthayhurst"
  "clipboard-history@alexsaveau.dev"
  "caffeine@patapon.info"
  "Vitals@CoreCoding.com"
  "auto-accent-colour@Wartybix"
  "compiz-alike-magic-lamp-effect@hermes83.github.com"
)

for extension in "${EXTENSIONS[@]}"; do
  gext install "$extension" || echo "Warning: Failed to install $extension (may not be compatible with current GNOME version)"
done

# Compile gsettings schemas in order to be able to set them
for schema in ~/.local/share/gnome-shell/extensions/*/schemas/*.gschema.xml; do
  if [ -f "$schema" ]; then
    sudo cp "$schema" /usr/share/glib-2.0/schemas/
  fi
done
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

# Configure Tactile
gsettings set org.gnome.shell.extensions.tactile col-0 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile col-1 2 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile col-2 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile col-3 0 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile row-0 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile row-1 1 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tactile gap-size 32 2>/dev/null || true

# Configure Just Perfection
gsettings set org.gnome.shell.extensions.just-perfection animation 2 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection dash-app-running true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection workspace true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection workspace-popup false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.just-perfection quick-settings-dark-mode false 2>/dev/null || true

# Configure Blur My Shell
gsettings set org.gnome.shell.extensions.blur-my-shell.appfolder blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.lockscreen blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.screenshot blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.window-list blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.panel blur false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.overview pipeline 'pipeline_default' 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock brightness 0.6 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock sigma 30 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock static-blur true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.blur-my-shell.dash-to-dock style-dash-to-dock 0 2>/dev/null || true

# Configure Space Bar
gsettings set org.gnome.shell.extensions.space-bar.behavior smart-workspace-names false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-activate-workspace-shortcuts false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts enable-move-to-workspace-shortcuts true 2>/dev/null || true
gsettings set org.gnome.shell.extensions.space-bar.shortcuts open-menu "@as []" 2>/dev/null || true

# Configure TopHat
gsettings set org.gnome.shell.extensions.tophat show-icons false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-cpu false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-disk false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-mem false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat show-fs false 2>/dev/null || true
gsettings set org.gnome.shell.extensions.tophat network-usage-unit bits 2>/dev/null || true

# Configure AlphabeticalAppGrid
gsettings set org.gnome.shell.extensions.alphabetical-app-grid folder-order-position 'end' 2>/dev/null || true
