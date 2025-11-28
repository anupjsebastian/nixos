{
  pkgs,
  lib,
  niri,
  ...
}:

{
  # Enable Niri window manager
  programs.niri = {
    enable = true;
    package = niri.packages.${pkgs.system}.niri-unstable;
  };

  # Enable display server infrastructure for Wayland
  services.xserver.enable = true;

  # Prevent xterm from being installed (pulled in by xserver)
  services.xserver.excludePackages = with pkgs; [ xterm ];

  # Use GDM as display manager
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Disable greetd (replaced by GDM)
  services.greetd.enable = false;

  # Disable regreet (not needed with GDM)
  programs.regreet.enable = false;

  # Set Niri as the default session
  services.displayManager.defaultSession = "niri";

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

  # Enable gnome-keyring PAM integration
  security.pam.services.login.enableGnomeKeyring = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

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

  # Lock screen handler for loginctl lock-session
  # This ensures when swayidle calls "loginctl lock-session", Noctalia's lock screen is triggered
  systemd.user.services.noctalia-lock = {
    description = "Noctalia lock screen";
    before = [ "sleep.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "noctalia-lock" ''
        noctalia-shell ipc call lock toggle
      ''}";
    };
  };

  # Register lock target
  systemd.user.targets.lock = {
    unitConfig = {
      Description = "Lock the session";
    };
  };

  systemd.user.services.noctalia-lock.wantedBy = [ "lock.target" ];

  # XDG portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # Enable Thunderbolt support for ethernet adapters
  services.hardware.bolt.enable = true;

  # Calendar events support (for Noctalia)
  services.gnome.evolution-data-server.enable = true;

  # Environment variables for proper theming
  environment.sessionVariables = {
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    GTK_THEME = "Adwaita:dark";
    GI_TYPELIB_PATH = lib.makeSearchPath "lib/girepository-1.0" (
      with pkgs;
      [
        evolution-data-server
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
    # GNOME apps to keep
    nautilus # File manager
    ptyxis # Terminal
    baobab # Disk usage analyzer
    loupe # Image viewer (GNOME's new image viewer)
    papers # Document viewer (Evince replacement)

    # Fallback terminal
    gnome-console

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
    papirus-icon-theme
    adwaita-icon-theme
  ];

  # Enable brightness control
  programs.light.enable = true;

  # Bluetooth support
  services.blueman.enable = true;
}
