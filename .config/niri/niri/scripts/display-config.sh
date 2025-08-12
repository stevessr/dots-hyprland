#!/bin/bash

# Unified display configuration script for niri
# Supports multiple graphical tools with fallback to command line

# Check for available display configuration tools
if command -v nwg-displays &> /dev/null; then
    echo "Using nwg-displays for display configuration"
    nwg-displays
elif command -v wdisplays &> /dev/null; then
    echo "Using wdisplays for display configuration"  
    wdisplays
elif command -v kanshi-gui &> /dev/null; then
    echo "Using kanshi-gui for display configuration"
    kanshi-gui
elif command -v wlr-randr &> /dev/null; then
    echo "Using wlr-randr for display configuration"
    # Launch a terminal with wlr-randr for command-line configuration
    if command -v kitty &> /dev/null; then
        kitty -e sh -c "echo 'Display Configuration with wlr-randr'; echo 'Current displays:'; wlr-randr; echo ''; echo 'Use: wlr-randr --output <name> --mode <resolution> --pos <x>,<y>'; echo 'Example: wlr-randr --output eDP-1 --mode 1920x1080 --pos 0,0'; echo ''; echo 'Press Enter to continue...'; read"
    else
        # Fallback to basic wlr-randr info
        wlr-randr
    fi
else
    # Final fallback - show notification about missing tools
    notify-send "Display Configuration" "No display configuration tool found. Please install: nwg-displays, wdisplays, or kanshi-gui" -i monitor
    echo "No display configuration tool found."
    echo "Please install one of: nwg-displays, wdisplays, kanshi-gui, or wlr-randr"
fi