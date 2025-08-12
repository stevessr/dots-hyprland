# Installing Niri for illogical-impulse

This guide will help you install and set up Niri as an alternative to Hyprland with the illogical-impulse configuration.

## Prerequisites

### 1. Install Niri

**Arch Linux:**
```bash
# From AUR
yay -S niri-git
# or
paru -S niri-git
```

**Other distributions:**
```bash
# Build from source
git clone https://github.com/YaLTeR/niri
cd niri
cargo build --release
sudo install target/release/niri /usr/local/bin/
```

### 2. Required Dependencies

Install the same dependencies as for Hyprland:

**Core dependencies:**
```bash
# Arch Linux example
sudo pacman -S \
  wayland wayland-protocols \
  xwayland \
  quickshell \
  fuzzel \
  grim slurp \
  wl-clipboard cliphist \
  brightnessctl \
  playerctl \
  fcitx5 \
  easyeffects \
  polkit-kde-agent \
  dbus

# AUR packages
yay -S wl-clip-persist
```

**Optional display management tools (choose one or more):**
```bash
# Graphical display configuration
yay -S nwg-displays    # Recommended
# or
sudo pacman -S wdisplays
# or  
yay -S kanshi-gui

# Command-line fallback
sudo pacman -S wlr-randr
```

**System management tools:**
```bash
# Network management
sudo pacman -S networkmanager plasma-nm

# Bluetooth management  
sudo pacman -S bluedevil bluez bluez-utils

# Audio control
sudo pacman -S pavucontrol-qt
# or
sudo pacman -S pavucontrol

# System settings
sudo pacman -S systemsettings  # KDE
# or
sudo pacman -S gnome-control-center  # GNOME
```

## Installation Steps

### 1. Configuration Files

The niri configuration is already included in this repository at `.config/niri/`.

### 2. Set Permissions

```bash
chmod +x ~/.config/niri/start-niri.sh
chmod +x ~/.config/niri/niri/scripts/*.sh
```

### 3. Login Manager Setup

**For SDDM (recommended):**
Create `/usr/share/wayland-sessions/niri.desktop`:
```ini
[Desktop Entry]
Name=Niri (illogical-impulse)
Comment=A scrollable-tiling Wayland compositor
Exec=/home/YOUR_USERNAME/.config/niri/start-niri.sh
Type=Application
```

**For GDM:**
The same `.desktop` file should work in `/usr/share/wayland-sessions/`.

### 4. Manual Start (for testing)

```bash
# From a TTY or existing session
~/.config/niri/start-niri.sh
```

## Post-Installation

### 1. Test System Menus

Test the system menu shortcuts:
- **Super+Ctrl+D** - Display configuration
- **Super+Ctrl+N** - Network settings  
- **Super+Ctrl+B** - Bluetooth settings
- **Super+Ctrl+A** - Audio settings
- **Super+Ctrl+S** - System settings

### 2. Customize

Add your personal customizations to files in `~/.config/niri/custom/`:
- Monitor configurations in `custom/monitors.kdl`
- Additional keybinds in `custom/keybinds.kdl`  
- Startup applications in `custom/execs.kdl`
- Environment variables in `custom/env.kdl`

### 3. Quickshell Setup

The niri configuration is designed to work with the existing Quickshell setup. Ensure Quickshell is properly configured and working.

## Troubleshooting

### Niri Won't Start
- Check that niri is properly installed: `which niri`
- Verify configuration syntax: `niri validate ~/.config/niri/config.kdl`
- Check logs: `journalctl -u display-manager` or `~/.local/share/niri/niri.log`

### System Menus Not Working
- Verify required applications are installed (nm-connection-editor, blueberry, etc.)
- Check if Quickshell is running: `pgrep qs`
- Test individual commands manually

### Display Configuration Issues
- Install a display management tool: `yay -S nwg-displays`
- For multi-monitor setup, edit `~/.config/niri/custom/monitors.kdl`

### XWayland Applications Not Working
- Ensure XWayland is installed: `sudo pacman -S xwayland`
- Check XWayland is enabled in the config (it should be by default)

## Switching Between Hyprland and Niri

You can switch between Hyprland and Niri at the login screen. Both configurations coexist and share the same Quickshell setup and system tools.

The configurations are designed to provide the same functionality and user experience, just with different window management paradigms (traditional workspaces vs. scrollable columns).

## Performance Notes

Niri is generally lighter than Hyprland as it doesn't include some advanced visual effects like blur. This can result in better performance on older hardware while maintaining the same functionality.