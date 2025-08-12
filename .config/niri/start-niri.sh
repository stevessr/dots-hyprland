#!/usr/bin/env bash

# Start niri with the illogical-impulse configuration
# This script ensures proper environment setup before launching niri

# Set the quickshell config variable
export qsConfig="ii"

# Set Wayland-specific environment variables
export QT_QPA_PLATFORM=wayland
export XDG_SESSION_TYPE=wayland
export XDG_CURRENT_DESKTOP=niri
export WAYLAND_DISPLAY=wayland-1

# Input method
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
export INPUT_METHOD=fcitx

# Terminal
export TERMINAL="kitty -1"

# Virtual environment for quickshell
export ILLOGICAL_IMPULSE_VIRTUAL_ENV=~/.local/state/quickshell/.venv

echo "Starting niri with illogical-impulse configuration..."
echo "Config location: ~/.config/niri/"

# Launch niri
exec niri --config ~/.config/niri/config.kdl