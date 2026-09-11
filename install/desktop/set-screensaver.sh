#!/bin/bash

# Configuration directories
SERVICE_DIR="$HOME/.config/systemd/user"
CONFIG_DIR="$HOME/.config/omakub/screensaver"
mkdir -p "$SERVICE_DIR" "$CONFIG_DIR" "$HOME/.config/alacritty"

# Ensure multi-monitor blackout dependencies are present
sudo apt install -y python3-gi gir1.2-gtk-3.0 >/dev/null 2>&1 || true

# Set default 5 minute (300 seconds) idle timeout if not configured
if [ ! -f "$CONFIG_DIR/idle_timeout" ]; then
  echo "300" > "$CONFIG_DIR/idle_timeout"
fi

# Copy screensaver Alacritty configuration
cp "${OMAKUB_PATH:-$HOME/.local/share/omakub}/configs/alacritty/screensaver.toml" "$HOME/.config/alacritty/screensaver.toml" 2>/dev/null || true

# Disable GNOME built-in screen blanking so the animated screensaver can run on screen
gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true

# Create systemd user service for auto-starting screensaver on idle
cat <<EOF > "$SERVICE_DIR/omakub-screensaver.service"
[Unit]
Description=Omakub ASCII Screensaver Idle Daemon
After=graphical-session.target

[Service]
Type=simple
ExecStart=/bin/bash -c "source ~/.local/share/omakub/bin/omakub-sub/screensaver-daemon.sh"
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF

# Reload and enable service
systemctl --user daemon-reload 2>/dev/null || true
systemctl --user enable --now omakub-screensaver.service 2>/dev/null || true
