{
  pkgs,
  lib,
  desktop,
  ...
}:
{
  config = lib.mkIf (desktop == "gnome") {
    # Enable display server infrastructure (required even for Wayland desktops).
    # This sets up GPU drivers, input handling, and XWayland compatibility.
    # GNOME will use Wayland by default when available.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.displayManager.gdm.enable = true; # Login Screen
    services.desktopManager.gnome.enable = true;

    # Enable fractional scaling for GNOME
    services.displayManager.gdm.wayland = true;

    # Prefer Wayland for Electron apps (VS Code, etc.)
    environment.sessionVariables = {
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    };

    # Install terminals
    environment.systemPackages = with pkgs; [
      ptyxis
    ];

    # Exclude unwanted packages from the system
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour # Welcome tour
      epiphany # Web browser
    ];

    # Prevent xterm from being installed (pulled in by xserver)
    services.xserver.excludePackages = with pkgs; [ xterm ];

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # Enable experimental features including fractional scaling
    programs.dconf.enable = true;
    programs.dconf.profiles.user.databases = [
      {
        settings = {
          "org/gnome/mutter" = {
            experimental-features = [ "scale-monitor-framebuffer" ];
          };
        };
      }
    ];
  };
}
