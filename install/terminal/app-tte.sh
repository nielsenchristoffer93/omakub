#!/bin/bash

# Install TerminalTextEffects for terminal animations and ASCII screensaver
pipx install terminaltexteffects --force 2>/dev/null || pipx upgrade terminaltexteffects 2>/dev/null || true
pipx runpip terminaltexteffects install pillow 2>/dev/null || true
