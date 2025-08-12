#!/bin/bash
# Display configuration script for niri
# This script provides a unified interface for display configuration tools

# Array of display configuration tools in order of preference
DISPLAY_TOOLS=(
    "nwg-displays"          # Graphical tool for Wayland
    "wdisplays"             # Another graphical tool for Wayland
    "kanshi-gui"            # GUI for kanshi display management
    "wlr-randr"             # Command-line tool for wlr-based compositors
)

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to launch the first available display tool
launch_display_config() {
    for tool in "${DISPLAY_TOOLS[@]}"; do
        if command_exists "$tool"; then
            echo "Launching $tool..."
            exec "$tool" "$@"
            return 0
        fi
    done
    
    # If no graphical tools are available, show available tools info
    echo "No graphical display configuration tool found."
    echo "Please install one of the following:"
    for tool in "${DISPLAY_TOOLS[@]}"; do
        echo "  - $tool"
    done
    
    # Show current display info as fallback
    if command_exists wlr-randr; then
        echo
        echo "Current display configuration:"
        wlr-randr
    elif command_exists swaymsg; then
        echo
        echo "Current display configuration:"
        swaymsg -t get_outputs
    else
        echo "No display information tool available."
    fi
    
    return 1
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "Display Configuration Script for Niri"
    echo
    echo "Usage: $0 [options]"
    echo
    echo "This script launches the first available display configuration tool:"
    for tool in "${DISPLAY_TOOLS[@]}"; do
        echo "  - $tool"
    done
    echo
    echo "Options are passed through to the underlying tool."
    exit 0
fi

# Launch display configuration
launch_display_config "$@"