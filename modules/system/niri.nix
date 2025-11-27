{
  pkgs,
  unstablePkgs,
  config,
  ...
}:
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

  # Essential GNOME services for overlays and functionality
  services.gnome = {
    gnome-keyring.enable = true;
    gnome-settings-daemon.enable = true;
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

  # XDG portal for screen sharing, file picker, etc.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config.common.default = "gnome";
  };

  # Install Niri and essential utilities
  environment.systemPackages = with pkgs; [
    # Launcher
    fuzzel

    # Notifications
    mako

    # Screen lock
    swaylock
    swayidle

    # Status bar
    waybar

    # GNOME apps to keep
    nautilus # File manager
    gnome-control-center # Settings
    ptyxis # Terminal
    gnome-console # Terminal (Ctrl+.)

    # System utilities
    pavucontrol # Volume control GUI
    networkmanagerapplet # Network manager tray
    blueman # Bluetooth manager

    # Screenshot tool
    grim
    slurp
    wl-clipboard

    # Brightness control
    brightnessctl
  ];

  # Niri configuration
  environment.etc."xdg/niri/config.kdl".text = ''
    // Niri configuration

    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        
        touchpad {
            tap
            natural-scroll
            accel-speed 0.3
        }
        
        mouse {
            accel-speed 0.2
        }
    }

    output "eDP-1" {
        scale 2.0
        mode "2880x1800@120"
    }

    layout {
        gaps 8
        center-focused-column "on-overflow"
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }
        
        focus-ring {
            width 2
            active-color "#7aa2f7"
            inactive-color "#3b4261"
        }
        
        border {
            width 2
            active-color "#7aa2f7"
            inactive-color "#3b4261"
        }
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png"

    animations {
        slowdown 0.8
        
        shaders {
            window-resize "default"
            window-open "default"
            window-close "default"
            workspace-switch "default"
        }
    }

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    binds {
        // Mod key is Super (Windows key)
        Mod+Return { spawn "ptyxis"; }
        Mod+D { spawn "fuzzel"; }
        Mod+Q { close-window; }
        
        // Window navigation (vim-style)
        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }
        
        // Window movement
        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }
        
        // Workspace switching
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }
        
        // Move window to workspace
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }
        
        // Column width adjustment
        Mod+Comma { set-column-width "-10%"; }
        Mod+Period { set-column-width "+10%"; }
        
        // Fullscreen
        Mod+F { fullscreen-window; }
        
        // Screenshot
        Print { spawn "grim" "-g" "$(slurp)" "-" "|" "wl-copy"; }
        Mod+Print { spawn "grim" "-" "|" "wl-copy"; }
        
        // System
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        
        // Volume (will show GNOME OSD)
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        
        // Brightness (will show GNOME OSD)
        XF86MonBrightnessUp { spawn "brightnessctl" "set" "5%+"; }
        XF86MonBrightnessDown { spawn "brightnessctl" "set" "5%-"; }
    }

    spawn-at-startup "mako"
    spawn-at-startup "waybar"
  '';

  # Waybar configuration
  environment.etc."xdg/waybar/config".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 32;

    modules-left = [
      "niri/workspaces"
      "niri/window"
    ];
    modules-center = [ "clock" ];
    modules-right = [
      "tray"
      "pulseaudio"
      "network"
      "battery"
    ];

    "niri/workspaces" = {
      format = "{icon}";
      format-icons = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        "5" = "5";
        "6" = "6";
        "7" = "7";
        "8" = "8";
        "9" = "9";
      };
    };

    "niri/window" = {
      max-length = 50;
    };

    clock = {
      format = "{:%a %b %d  %I:%M %p}";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-icons = [
        ""
        ""
        ""
        ""
        ""
      ];
    };

    network = {
      format-wifi = " {signalStrength}%";
      format-ethernet = "";
      format-disconnected = "⚠";
      tooltip-format = "{ifname}: {ipaddr}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = " {volume}%";
      format-icons = {
        default = [
          ""
          ""
          ""
        ];
      };
      on-click = "pavucontrol";
    };

    tray = {
      spacing = 10;
    };
  };

  # Waybar styling
  environment.etc."xdg/waybar/style.css".text = ''
    * {
        font-family: "JetBrainsMono Nerd Font", monospace;
        font-size: 13px;
    }

    window#waybar {
        background-color: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        border-bottom: 2px solid #7aa2f7;
    }

    #workspaces button {
        padding: 0 10px;
        color: #cdd6f4;
        background-color: transparent;
        border: none;
    }

    #workspaces button.active {
        background-color: #7aa2f7;
        color: #1e1e2e;
    }

    #workspaces button:hover {
        background-color: rgba(122, 162, 247, 0.3);
    }

    #window,
    #clock,
    #battery,
    #network,
    #pulseaudio,
    #tray {
        padding: 0 15px;
    }

    #battery.charging {
        color: #a6e3a1;
    }

    #battery.warning:not(.charging) {
        color: #f9e2af;
    }

    #battery.critical:not(.charging) {
        color: #f38ba8;
    }

    #pulseaudio.muted {
        color: #585b70;
    }
  '';

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
}
