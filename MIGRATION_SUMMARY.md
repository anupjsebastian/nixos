# NixOS Migration: GNOME → Noctalia + Niri with Home Manager

## Migration Summary

Successfully migrated your NixOS configuration from GNOME to Noctalia shell with Niri window manager, utilizing Home Manager for user-level configuration.

## What Changed

### 1. **Flake Updates** ✅
- Switched from `nixos-25.11` to `nixos-unstable` (required for Noctalia)
- Added `home-manager` input for user-level configuration
- Added `noctalia` flake input for Noctalia shell
- Removed `unstablePkgs` - now using unstable as main channel

### 2. **Desktop Environment** ✅
- **Removed**: GNOME Desktop Environment
- **Removed**: GDM (GNOME Display Manager)
- **Added**: Noctalia shell (provides launcher, notifications, lock screen, settings)
- **Added**: greetd + regreet (themeable Wayland login greeter)
- **Kept**: Niri window manager (now configured via Home Manager)

### 3. **GNOME Apps Kept** ✅
- `nautilus` - File manager
- `ptyxis` - Terminal
- `baobab` - Disk usage analyzer
- `gnome-disks` - Disk utility
- `loupe` - Image viewer (GNOME's new image viewer)
- `papers` - Document viewer (Evince replacement in GNOME 47+)
- `gnome-console` - Fallback terminal

### 4. **Removed/Replaced Services** ✅
- **Removed**: Waybar (replaced by Noctalia's bar)
- **Removed**: Mako (replaced by Noctalia's notifications)
- **Removed**: Rofi launcher (replaced by Noctalia's launcher)
- **Removed**: Swaylock (replaced by Noctalia's lock screen)
- **Kept**: swayidle (for power management)
- **Kept**: nm-applet, waypaper, swaybg

### 5. **Home Manager Migration** ✅
New user-level configuration structure:
```
home.nix                    # Main home-manager config
modules/home/
  ├── niri.nix             # Niri + Noctalia configuration
  └── shell.nix            # Shell tools (starship, yazi, btop, fastfetch)
```

**Migrated to Home Manager**:
- Niri window manager configuration (all settings)
- Noctalia shell configuration
- Shell tools (starship, yazi)
- CLI utilities (btop, fastfetch)

**Kept as System Packages** (per your request):
- VSCode (synced via GitHub)
- Neovim (using dotfiles)

### 6. **Configuration Changes** ✅
- All `unstablePkgs` references changed to `pkgs`
- Niri keybindings now use Noctalia IPC calls
- Tokyo Night theme applied to Noctalia
- greetd configured with regreet greeter

## New File Structure

```
.
├── flake.nix                          # Updated with home-manager & noctalia
├── home.nix                           # Home Manager entry point (NEW)
├── hosts/nyx/
│   └── configuration.nix              # System configuration (updated)
└── modules/
    ├── home/                          # Home Manager modules (NEW)
    │   ├── niri.nix                  # Niri + Noctalia config
    │   └── shell.nix                 # Shell tools
    └── system/
        ├── noctalia.nix              # Noctalia system config (NEW)
        ├── fonts.nix
        └── network.nix
```

## Key Features

### Noctalia Integration
Noctalia provides a complete desktop shell with:
- **Launcher** (Mod+Space) - Application launcher
- **Lock Screen** (Mod+Shift+L) - Screen locking
- **Session Menu** (Mod+P) - Power/logout menu
- **Notifications** - Built-in notification system
- **Bar** - Top bar with workspace, clock, battery, wifi, bluetooth, system monitor
- **Settings** - WiFi, Bluetooth, power profiles, brightness controls
- **Calendar** - Events via evolution-data-server

### Niri Window Manager
Configured via Home Manager with:
- Vim-style navigation (Mod+H/J/K/L)
- Workspace management (Mod+1-9)
- Tokyo Night theme colors
- 1.5x scaling on DP-5 (3840x2160@240Hz)
- 8px gaps, rounded corners
- Window animations

### Login Experience
- **greetd + regreet**: Modern, themeable Wayland greeter
- Dark theme applied
- Matches desktop aesthetics better than GDM

## Keybindings Reference

### Noctalia
- `Mod+Space` - Open launcher
- `Mod+Shift+L` - Lock screen
- `Mod+P` - Session menu (power/logout)
- `XF86AudioRaiseVolume/Lower/Mute` - Volume (with Noctalia OSD)
- `XF86MonBrightnessUp/Down` - Brightness (with Noctalia OSD)

### Applications
- `Mod+Return` - Terminal (ptyxis)
- `Mod+B` - Browser (Chrome)
- `Mod+N` - File manager (Nautilus)
- `Mod+T` - System monitor (btop)
- `Mod+Y` - File manager TUI (yazi)

### Window Management
- `Mod+Q` - Close window
- `Mod+H/J/K/L` - Focus left/down/up/right
- `Mod+Shift+H/J/K/Right` - Move window
- `Mod+1-9` - Switch workspace
- `Mod+Shift+1-9` - Move window to workspace
- `Mod+F` - Maximize column
- `Mod+Shift+F` - Fullscreen

## Next Steps

### 1. Update Flake Lock
```bash
nix flake update
```

### 2. Build and Test
```bash
sudo nixos-rebuild test --flake .#nyx
```

### 3. If Everything Works, Switch
```bash
sudo nixos-rebuild switch --flake .#nyx
```

### 4. Reboot to Use New Login Manager
```bash
reboot
```

### 5. First Login
- You'll see the new regreet greeter (themeable GTK4 login screen)
- Select your user and log in
- Noctalia will start automatically via systemd
- Niri window manager will be running
- Press `Mod+Space` to open the launcher

## Customization

### Noctalia Settings
Edit `modules/home/niri.nix`:
- Bar position, widgets, density
- Color scheme (Tokyo Night applied)
- Notifications settings

You can also configure Noctalia via GUI:
1. Open control center from bar
2. Make changes
3. Run: `diff <(jq -S . ~/.config/noctalia/settings.json) <(jq -S . ~/.config/noctalia/gui-settings.json)`
4. Apply permanent changes to niri.nix

### Niri Settings
Edit `modules/home/niri.nix`:
- Layout gaps, borders, focus ring
- Display configuration
- Keybindings
- Window rules

### greetd Greeter Theme
Edit `modules/system/noctalia.nix`:
- Background image path
- GTK theme
- Icon theme
- Font

## Troubleshooting

### If Noctalia doesn't start
Check systemd service status:
```bash
systemctl --user status noctalia-shell.service
journalctl --user -u noctalia-shell.service
```

### If WiFi/Bluetooth widgets don't work
Ensure services are enabled (already done in noctalia.nix):
```nix
networking.networkmanager.enable = true;
hardware.bluetooth.enable = true;
services.power-profiles-daemon.enable = true;
services.upower.enable = true;
```

### Calendar events not showing
Evolution data server is enabled. If needed, install GNOME Calendar:
```bash
nix-shell -p gnome-calendar
gnome-calendar  # Add your calendar accounts
```

### Custom wallpaper not loading
Update the startup command in `modules/home/niri.nix`:
```nix
spawn-at-startup = [
  { command = [ "waypaper" "--restore" ]; }
];
```

Or set a specific wallpaper:
```nix
{ command = [ "swaybg" "-i" "/path/to/wallpaper.jpg" ]; }
```

## References

- [Noctalia Documentation](https://docs.noctalia.dev/)
- [Noctalia NixOS Guide](https://docs.noctalia.dev/getting-started/nixos/)
- [Niri Documentation](https://github.com/YaLTeR/niri)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)

## Rollback

If you need to rollback:
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback to previous generation
sudo nixos-rebuild switch --rollback

# Or boot into previous generation from boot menu
```
