# Niri Configuration for illogical-impulse

This directory contains a complete Niri configuration that provides an equivalent experience to the Hyprland setup for the illogical-impulse theme.

## Structure

The configuration follows the same modular structure as the Hyprland config:

```
.config/niri/
├── config.kdl              # Main configuration entry point  
├── niri/                   # Base configuration modules
│   ├── env.kdl            # Environment variables and XWayland
│   ├── execs.kdl          # Autostart applications
│   ├── general.kdl        # Layout, input, and core settings
│   ├── rules.kdl          # Window behavior rules
│   ├── colors.kdl         # Color scheme
│   ├── keybinds.kdl       # Key bindings
│   └── scripts/           # Supporting scripts
└── custom/                # User override files
    ├── env.kdl
    ├── execs.kdl
    ├── general.kdl
    ├── rules.kdl
    ├── keybinds.kdl
    ├── devices.kdl
    ├── monitors.kdl
    └── mouse.kdl
```

## Key Features

### XWayland Support
- Full XWayland configuration for X11 application compatibility
- Proper environment variables for hybrid Wayland/X11 desktop

### System Management & Menus  
- **Super+Ctrl+D** - Display/monitor configuration (graphical)
- **Super+Ctrl+N** - Network settings menu
- **Super+Ctrl+B** - Bluetooth settings menu
- **Super+Ctrl+A** - Audio settings menu
- **Super+Ctrl+S** - System settings
- **Super+Ctrl+Q** - Quick settings panel

### Multi-Monitor Display Management
- Support for nwg-displays, wdisplays, kanshi-gui
- Command-line fallback with wlr-randr
- Unified configuration script with automatic tool detection

### Enhanced Integration
- **Quickshell Compatibility** - Full compatibility with existing widgets
- **Audio/Brightness Controls** - All hardware function keys preserved  
- **Screenshot & Recording** - Complete screen capture functionality
- **Column-based Window Management** - Adapted for niri's scrollable tiling

## Key Differences from Hyprland

- **Scrollable Tiling**: Uses niri's unique column-based layout instead of traditional workspaces
- **No Blur Effects**: Visual effects simplified due to niri's current capabilities
- **Column-based Focus**: Window management adapted to niri's paradigm
- **XWayland Integration**: Proper X11 application support configured

## Customization

Add your personal customizations to files in the `custom/` directory:
- `custom/env.kdl` - Environment variables
- `custom/execs.kdl` - Startup applications  
- `custom/general.kdl` - Layout and input settings
- `custom/rules.kdl` - Window rules
- `custom/keybinds.kdl` - Key bindings
- `custom/devices.kdl` - Device-specific settings
- `custom/monitors.kdl` - Monitor configuration
- `custom/mouse.kdl` - Mouse settings

This ensures your customizations won't be overwritten when updating the base configuration.

## Installation

See `INSTALL.md` for detailed installation instructions.