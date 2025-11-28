{
  pkgs,
  unstablePkgs,
  config,
  ...
}:
let
  # Import all submodules
  displayConfig = import ./display.nix;
  inputConfig = import ./input.nix;
  layoutConfig = import ./layout.nix;
  keybindingsConfig = import ./keybindings.nix { inherit pkgs; };
  appearanceConfig = import ./appearance.nix;
  waybarConfig = import ./waybar.nix { inherit pkgs; };
  rofiConfig = import ./rofi.nix;
  startupConfig = import ./startup.nix;
in
{
  # Enable Niri window manager
  programs.niri = {
    enable = true;
    package = unstablePkgs.niri;
  };

  # Enable display server infrastructure for Wayland
  services.xserver.enable = true;

  # Keep GDM as login manager (shows Niri session)
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Set Niri as the default session
  services.displayManager.defaultSession = "niri";

  # Essential GNOME services for overlays and functionality
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-settings-daemon.enable = true;
  };

  # Enable gnome-keyring PAM integration
  security.pam.services.login.enableGnomeKeyring = true;

  # Environment variables for GNOME apps
  environment.sessionVariables = {
    # Required for GNOME Control Center
    XDG_CURRENT_DESKTOP = "GNOME";
    XDG_SESSION_TYPE = "wayland";
    GTK_THEME = "Adwaita:dark";
  };

  # Polkit authentication agent (for sudo prompts, etc.)
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

  # Swaylock lock handler for loginctl lock-session
  systemd.user.services.swaylock = {
    description = "Swaylock screen locker";
    before = [ "sleep.target" ];
    serviceConfig = {
      Type = "forking";
      ExecStart = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };

  # Disable automatic suspend
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchDocked = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandlePowerKey = "ignore";
    IdleAction = "ignore";
  };

  # XDG portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # Enable Thunderbolt support for ethernet adapters
  services.hardware.bolt.enable = true;

  # Ensure ethernet devices are managed
  networking.networkmanager.unmanaged = [ ];

  # Install Niri and essential utilities
  environment.systemPackages = with pkgs; [
    # Niri default packages (fallback launcher/terminal)
    alacritty
    fuzzel

    # Launcher
    rofi
    rofi-power-menu

    # Notifications
    mako

    # Screen lock
    swaylock
    swayidle

    # Status bar
    waybar

    # GNOME apps to keep
    nautilus # File manager
    ptyxis # Terminal
    gnome-console # Terminal (Ctrl+.)

    # System utilities
    pavucontrol # Volume control GUI
    networkmanagerapplet # Network manager tray
    blueman # Bluetooth manager

    # TUI Settings apps
    bluetuith # Bluetooth TUI
    wdisplays # Display configuration GUI

    # Alternative settings panels
    nwg-look # GTK theme switcher
    lxappearance # GTK settings

    # Screenshot tool
    grim
    slurp
    wl-clipboard

    # Brightness control
    brightnessctl

    # Wallpaper
    swaybg
    swww # Animated wallpaper daemon
    waypaper # GUI wallpaper picker

    # Theme
    tokyonight-gtk-theme
    papirus-icon-theme
  ];

  # Niri configuration - combine all modules
  environment.etc."xdg/niri/config.kdl".text = ''
        // Niri configuration

    ${inputConfig.config}

    ${displayConfig.config}

    ${layoutConfig.config}

    ${appearanceConfig.config}

    ${keybindingsConfig.config}

    ${startupConfig.config}
  '';

  # Waybar configuration
  environment.etc."xdg/waybar/config".text = waybarConfig.config;

  # Waybar styling
  environment.etc."xdg/waybar/style.css".text = waybarConfig.style;

  # Mako notification daemon config
  environment.etc."xdg/mako/config".text = ''
    font=Sans 12
    background-color=#1e1e2e
    text-color=#cdd6f4
    border-color=#7aa2f7
    border-size=2
    border-radius=8
    padding=15
    margin=10
    default-timeout=5000
    ignore-timeout=0

    [urgency=high]
    border-color=#f38ba8
  '';

  # Add brightnessctl for brightness control
  programs.light.enable = true;

  # Link niri config to user directory
  system.activationScripts.niriUserConfig = ''
        NIRI_USER_DIR="/home/anupjsebastian/.config/niri"
        mkdir -p "$NIRI_USER_DIR"
        ln -sf /etc/xdg/niri/config.kdl "$NIRI_USER_DIR/config.kdl"
        chown -R anupjsebastian:users "$NIRI_USER_DIR"
        
        # Setup rofi config
        ROFI_DIR="/home/anupjsebastian/.config/rofi"
        mkdir -p "$ROFI_DIR"
        cat > "$ROFI_DIR/config.rasi" << 'EOF'
    ${rofiConfig.theme}
    EOF
        chown -R anupjsebastian:users "$ROFI_DIR"
  '';
}
