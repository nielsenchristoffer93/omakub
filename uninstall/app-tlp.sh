#!/bin/bash

# Uninstall TLP and restore GNOME power-profiles-daemon
sudo systemctl disable --now tlp 2>/dev/null || true
sudo systemctl unmask power-profiles-daemon 2>/dev/null || true
sudo systemctl start power-profiles-daemon 2>/dev/null || true
sudo apt remove --purge -y tlp tlp-rdw
