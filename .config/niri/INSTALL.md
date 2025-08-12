# Niri Installation Guide

## Quick Start

1. **Install Niri**:
   ```bash
   # Arch Linux
   yay -S niri-git
   
   # Other distributions: See https://github.com/YaLTeR/niri
   ```

2. **Copy Configuration**:
   ```bash
   # If you already have the dots-hyprland repo
   ln -sf ~/path/to/dots-hyprland/.config/niri ~/.config/niri
   
   # Or copy the directory
   cp -r .config/niri ~/.config/
   ```

3. **Install Dependencies** (same as Hyprland setup):
   - quickshell
   - wf-recorder, slurp, grim
   - fuzzel, cliphist
   - kitty, fcitx5
   - All other dependencies from the main setup

4. **Start Niri**:
   ```bash
   # From a TTY or existing session
   ~/.config/niri/start-niri.sh
   
   # Or directly
   niri --config ~/.config/niri/config.kdl
   ```

5. **Session Manager Integration**:
   Add niri to your display manager by creating `/usr/share/wayland-sessions/niri.desktop`:
   ```ini
   [Desktop Entry]
   Name=Niri
   Comment=A scrollable-tiling Wayland compositor
   Exec=/home/YOUR_USERNAME/.config/niri/start-niri.sh
   Type=Application
   ```

## Customization

Edit files in `.config/niri/custom/` to add your personal settings without modifying the base configuration.

## Troubleshooting

- Check niri logs: `journalctl --user -u niri -f`
- Ensure all dependencies are installed
- Verify quickshell is working: `qs -c ii`
- For keybinding issues, check `.config/niri/niri/binds.kdl`