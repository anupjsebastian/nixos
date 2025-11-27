{ pkgs, ... }:
{
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

  # Install Ptyxis (modern GNOME terminal)
  environment.systemPackages = with pkgs; [
    ptyxis
  ];

  # Exclude default GNOME apps we don't need
  environment.gnome.excludePackages = with pkgs; [
    gnome-console # Old GNOME Console
    gnome-terminal # Old GNOME Terminal
  ];

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

        # # Custom keyboard shortcuts
        # "org/gnome/settings-daemon/plugins/media-keys" = {
        #   custom-keybindings = [
        #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        #   ];
        # };

        # # Super+Enter: Open terminal
        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        #   name = "Terminal";
        #   command = "ptyxis";
        #   binding = "<Super>Return";
        # };

        # Additional shortcut examples (uncomment and modify as needed)
        # Example: VS Code shortcut (Super+C)
        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4" = {
        #   name = "VS Code";
        #   command = "code";
        #   binding = "<Super>c";
        # };
      };
    }
  ];
}
