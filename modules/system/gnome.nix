{ ... }:
{
  # Enable display server infrastructure (required even for Wayland desktops).
  # This sets up GPU drivers, input handling, and XWayland compatibility.
  # GNOME will use Wayland by default when available.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true; # Login Screen
  services.xserver.desktopManager.gnome.enable = true;

  # Enable fractional scaling for GNOME
  services.xserver.displayManager.gdm.wayland = true;

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

        # Custom keyboard shortcuts (examples - uncomment and modify as needed)
        # "org/gnome/settings-daemon/plugins/media-keys" = {
        #   custom-keybindings = [
        #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        #     "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
        #   ];
        # };

        # Example: Terminal shortcut (Super+T)
        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        #   name = "Terminal";
        #   command = "gnome-terminal";
        #   binding = "<Super>t";
        # };

        # Example: VS Code shortcut (Super+C)
        # "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
        #   name = "VS Code";
        #   command = "code";
        #   binding = "<Super>c";
        # };
      };
    }
  ];
}
