#!/bin/bash

# Niri startup script for illogical-impulse

# Set the config directory
export NIRI_CONFIG_DIR="$HOME/.config/niri"

# Ensure Wayland environment is set up
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=niri
export QT_QPA_PLATFORM=wayland
export GDK_BACKEND=wayland

# Start niri with our config
if command -v niri &> /dev/null; then
    echo "Starting niri with illogical-impulse configuration..."
    exec niri --config "$NIRI_CONFIG_DIR/config.kdl"
else
    echo "Error: niri is not installed"
    echo "Please install niri first: https://github.com/YaLTeR/niri"
    exit 1
fi