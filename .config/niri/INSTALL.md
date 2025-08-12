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

3. **Install Dependencies**:
   
   **Core Dependencies** (same as Hyprland setup):
   - quickshell
   - wf-recorder, slurp, grim
   - fuzzel, cliphist
   - kitty, fcitx5
   - All other dependencies from the main setup

   **Additional Dependencies for Niri**:
   - **Display Management** (install at least one):
     - `nwg-displays` (recommended graphical tool)
     - `wdisplays` (alternative graphical tool) 
     - `kanshi` + `kanshi-gui` (configuration-based display management)
     - `wlr-randr` (command-line tool, minimal fallback)
   
   - **Network & Bluetooth Management**:
     - `networkmanager` + `plasma-nm` (for network GUI)
     - `bluez` + `bluez-utils` + `bluedevil` (for Bluetooth)
     - `systemsettings` (KDE system settings)
   
   - **XWayland Support**:
     - `xwayland` (for X11 application compatibility)
   
   **Installation Examples**:
   ```bash
   # Arch Linux
   yay -S niri-git nwg-displays wlr-randr xwayland plasma-nm bluedevil systemsettings
   
   # Fedora
   sudo dnf install niri nwg-displays wlr-randr xwayland NetworkManager-wifi bluedevil systemsettings
   
   # Ubuntu/Debian (may need additional repositories for niri)
   sudo apt install wlr-randr xwayland network-manager-gnome blueman
   ```

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