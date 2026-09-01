#!/bin/bash

# TLP - Advanced Power Management for Linux Laptops https://linrunner.de/tlp/
sudo apt install -y tlp tlp-rdw

# Mask power-profiles-daemon to prevent conflicts on GNOME
sudo systemctl mask power-profiles-daemon 2>/dev/null || true

# Enable and start TLP service
sudo systemctl enable --now tlp
