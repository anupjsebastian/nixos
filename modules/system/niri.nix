{
  pkgs,
  lib,
  niri,
  desktop,
  ...
}:

{
  config = lib.mkIf (desktop == "niri") {
    # Enable Niri window manager
    programs.niri = {
      enable = true;
      package = niri.packages.${pkgs.stdenv.hostPlatform.system}.niri-unstable;
    };

    # Load i2c-dev module for ddcutil (brightness control)
    boot.kernelModules = [ "i2c-dev" ];

    # Configure udev rules for i2c devices (for ddcutil)
    services.udev.extraRules = ''
      KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
    '';

    # Create i2c group
    users.groups.i2c = { };

    # Add user to i2c group (for ddcutil brightness control)
    users.users.anupjsebastian.extraGroups = [ "i2c" ];

    # Enable display server infrastructure for Wayland
    services.xserver.enable = true;

    # Prevent xterm from being installed (pulled in by xserver)
    services.xserver.excludePackages = with pkgs; [ xterm ];

    # Use greetd with tuigreet as display manager
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session --theme 'container=black;border=lightblue;text=white;prompt=lightmagenta;time=lightblue;action=lightcyan;button=lightgreen;input=lightmagenta' --cmd niri-session";
          user = "greeter";
        };
      };
    };

    # Tokyo Night colors for TTY/console (used by tuigreet)
    console.colors = [
      "1a1b26" # black (Tokyo Night background)
      "f7768e" # red
      "9ece6a" # green
      "e0af68" # yellow
      "7aa2f7" # blue
      "bb9af7" # magenta
      "7dcfff" # cyan
      "a9b1d6" # white
      "414868" # bright black (darker gray)
      "f7768e" # bright red
      "9ece6a" # bright green
      "e0af68" # bright yellow
      "7aa2f7" # bright blue
      "bb9af7" # bright magenta
      "7dcfff" # bright cyan
      "c0caf5" # bright white
    ];

    # Essential services for Noctalia features
    networking.networkmanager.enable = true;
    hardware.bluetooth.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    # GNOME services for keyring and polkit
    services.gnome = {
      gnome-keyring.enable = true;
    };

    # Enable gvfs for Nautilus trash and virtual filesystem support
    services.gvfs.enable = true;

    # Enable Thunar thumbnail support
    services.tumbler.enable = true;

    # Enable gnome-keyring PAM integration
    security.pam.services.login.enableGnomeKeyring = true;
    security.pam.services.greetd.enableGnomeKeyring = true;

    # Polkit authentication agent
    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    # XDG portal for screen sharing, file picker, etc.
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common.default = "gtk";
    };

    # Enable Thunderbolt support for ethernet adapters
    services.hardware.bolt.enable = true;

    # Environment variables for proper theming
    environment.sessionVariables = {
      XDG_CURRENT_DESKTOP = "niri";
      XDG_SESSION_TYPE = "wayland";
      GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
        with pkgs;
        [
          libical
          glib.out
          libsoup_3
          json-glib
          gobject-introspection
        ]
      );
    };

    # Install GNOME apps and system utilities
    environment.systemPackages = with pkgs; [
      # Terminal
      ptyxis

      # Thunar file manager
      xfce.thunar
      xfce.thunar-volman # Removable media support
      xfce.thunar-archive-plugin # Archive support

      # GNOME utilities
      baobab # Disk usage analyzer
      loupe # Image viewer
      papers # Document viewer

      # Python for calendar support
      (python3.withPackages (pyPkgs: with pyPkgs; [ pygobject3 ]))

      # System utilities
      pavucontrol # Volume control GUI
      blueman # Bluetooth manager

      # Display configuration
      wdisplays # Display configuration GUI

      # GTK theme tools
      nwg-look # GTK theme switcher
      lxappearance # GTK settings

      # Screenshot tools
      grim
      slurp

      # Brightness control
      brightnessctl

      # Theme
      tokyonight-gtk-theme
      kanagawa-gtk-theme
      kanagawa-icon-theme
      adwaita-icon-theme
    ];

    # Enable brightness control
    programs.light.enable = true;

    # Bluetooth support
    services.blueman.enable = true;
  };
}
