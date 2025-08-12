# Niri Configuration for end_4's dots

This directory contains a niri configuration that aims to provide a similar experience to the Hyprland setup in this repository.

## Overview

Niri is a scrollable-tiling Wayland compositor. This configuration adapts the illogical-impulse setup from Hyprland to work with niri's unique paradigm.

## Features

### Core Features
- **XWayland Support**: Full compatibility with X11 applications
- **Quickshell Integration**: Complete compatibility with existing illogical-impulse widgets
- **Audio/Media Controls**: Full hardware function key support
- **Screenshot & Recording**: Screen capture functionality adapted for niri
- **System Menus**: Easy access to network, bluetooth, and display settings

### New Keybindings for System Management
- `Super+Ctrl+D` - Display/monitor configuration (graphical)
- `Super+Ctrl+N` - Network settings menu
- `Super+Ctrl+B` - Bluetooth settings menu
- `Super+Ctrl+A` - Audio settings menu
- `Super+Ctrl+S` - System settings
- `Super+Ctrl+Q` - Quick settings panel
- `Super+Ctrl+T` - Task manager
- `Super+Shift+N` - Network connection editor
- `Super+Shift+B` - Bluetooth device wizard

### Display Management
Multiple tools supported for monitor configuration:
- **nwg-displays** (preferred graphical tool)
- **wdisplays** (alternative graphical tool)
- **kanshi-gui** (GUI for kanshi)
- **wlr-randr** (command-line fallback)

## Structure

- `config.kdl` - Main configuration file that imports all other configs
- `niri/` - Default niri configuration modules
  - `environment.kdl` - Environment variables (including XWayland)
  - `input.kdl` - Input device configuration
  - `layout.kdl` - Layout and appearance settings
  - `xwayland.kdl` - XWayland configuration
  - `spawn-at-startup.kdl` - Autostart applications
  - `window-rules.kdl` - Window rules and behaviors
  - `binds.kdl` - Key bindings
  - `system-menus.kdl` - System menu and configuration shortcuts
  - `screenshot.kdl` - Screenshot settings
  - `animations.kdl` - Animation configuration
  - `decoration.kdl` - Window decorations
  - `scripts/` - Helper scripts
    - `display-config.sh` - Unified display configuration script
    - `record.sh` - Screen recording script
    - `start_geoclue_agent.sh` - Location services
- `custom/` - Custom user overrides (add your changes here)

## Installation

1. Install niri: Follow the [niri installation guide](https://github.com/YaLTeR/niri)
2. Ensure dependencies are installed (same as Hyprland setup):
   - quickshell
   - wf-recorder
   - slurp
   - grim
   - fuzzel
   - etc.
3. Copy or symlink this niri configuration to your config directory
4. Start niri with: `niri`

## Key Differences from Hyprland

- **Layout**: Niri uses a scrollable tiling layout instead of traditional workspaces
- **No blur effects**: Niri doesn't support blur, so visual effects are simplified
- **Different window management**: Focus on column-based layout
- **Monitor handling**: Different approach to multi-monitor setups

## Quickshell Integration

The configuration is set up to work with the same Quickshell widgets as the Hyprland setup:
- Overview/launcher
- Sidebars
- Status bar
- Media controls
- On-screen keyboard
- Session menu

## Key Bindings

Most key bindings are preserved from the Hyprland configuration:
- `Super` - Overview/launcher
- `Super+Return` - Terminal
- `Super+Q` - Close window
- `Super+A` - Left sidebar
- `Super+N` - Right sidebar
- `Super+Shift+S` - Screenshot
- etc.

See `niri/binds.kdl` for the complete list.

## Customization

Add your custom settings to files in the `custom/` directory:
- `custom/environment.kdl` - Custom environment variables
- `custom/input.kdl` - Input device overrides
- `custom/layout.kdl` - Layout customizations
- `custom/spawn-at-startup.kdl` - Additional autostart programs
- `custom/window-rules.kdl` - Custom window rules
- `custom/binds.kdl` - Additional key bindings
- `custom/monitors.kdl` - Monitor configuration

## Notes

- This is an experimental configuration adapting Hyprland concepts to niri
- Some features may not work exactly the same due to compositor differences
- Niri is still in active development, so some features may change
- The Quickshell integration should work but may need adjustments for niri-specific features