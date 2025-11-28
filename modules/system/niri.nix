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
    # nmtui comes with networkmanager (already enabled in network.nix)
    bluetuith # Bluetooth TUI
    wdisplays # Display configuration GUI

    # Alternative settings panels
    nwg-look # GTK theme switcher
    lxappearance # GTK settings    # Alternative settings panels
    nwg-look # GTK theme switcher
    lxappearance # GTK settings    # Screenshot tool
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
  ]; # Niri configuration
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

    output "DP-5" {
        scale 1.5
        mode "3840x2160@240"
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
        }

        window-rule {
            geometry-corner-radius 8
            clip-to-geometry true
        }

        hotkey-overlay {
            skip-at-startup
        }

    binds {
        // Mod key is Super (Windows key)
        Mod+Shift+Slash { show-hotkey-overlay; }
        
        Mod+Return { spawn "ptyxis" "--new-window"; }
        Mod+Space { spawn "rofi" "-show" "drun"; }
        Mod+B { spawn "google-chrome-stable"; }
        Mod+Q { close-window; }
        
        // Column/Window resizing
        Mod+R { switch-preset-column-width; }
        Mod+Shift+R { switch-preset-window-height; }
        Mod+Ctrl+R { reset-window-height; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        
        // Screenshots
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
        
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
        
        // Workspace navigation
        Mod+U { focus-workspace-down; }
        Mod+I { focus-workspace-up; }
        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up { focus-workspace-up; }
        
        // Move window to workspace up/down
        Mod+Ctrl+U { move-column-to-workspace-down; }
        Mod+Ctrl+I { move-column-to-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up { move-column-to-workspace-up; }
        
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
        
        // Consume/expel windows
        Mod+BracketLeft { consume-or-expel-window-left; }
        Mod+BracketRight { consume-or-expel-window-right; }
        
        // Floating/tiling toggle
        Mod+V { toggle-window-floating; }
        Mod+Shift+V { switch-focus-between-floating-and-tiling; }
        
        // Center column
        Mod+C { center-column; }
        
        // Overview
        Mod+O { toggle-overview; }
        
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
    spawn-at-startup "nm-applet" "--indicator"
    spawn-at-startup "waypaper" "--restore"
    spawn-at-startup "sh" "-c" "swaybg -c '#bb9af7'"
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
      "custom/terminal"
      "tray"
      "pulseaudio"
      "network"
      "battery"
      "custom/power"
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

    "custom/power" = {
      format = "⏻";
      tooltip = false;
      on-click = "rofi -show power-menu -modi power-menu:${pkgs.rofi-power-menu}/bin/rofi-power-menu";
    };

    "custom/terminal" = {
      format = "";
      tooltip = false;
      on-click = "ptyxis --new-window";
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
      format-wifi = "  {signalStrength}%";
      format-ethernet = "󰈀 ";
      format-disconnected = "󰖪 ";
      tooltip-format = "{ifname}: {ipaddr}";
    };

    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "󰖁 {volume}%";
      format-icons = {
        default = [
          "󰕿"
          "󰖀"
          "󰕾"
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
        font-family: "ZedMono Nerd Font", "Noto Sans", sans-serif;
        font-size: 14px;
        font-weight: 500;
    }

    window#waybar {
        background-color: rgba(24, 24, 37, 0.95);
        color: #cdd6f4;
        border-bottom: 3px solid #89b4fa;
        transition: all 0.3s ease;
    }

    #workspaces button {
        padding: 0 12px;
        margin: 0 2px;
        color: #bac2de;
        background-color: transparent;
        border: none;
        border-radius: 8px;
        transition: all 0.2s ease;
    }

    #workspaces button.active {
        background-color: #89b4fa;
        color: #11111b;
        font-weight: 700;
    }

    #workspaces button:hover {
        background-color: rgba(137, 180, 250, 0.3);
        color: #cdd6f4;
    }

    #window {
        margin: 0 10px;
        padding: 0 15px;
        color: #94e2d5;
        font-weight: 600;
    }

    #clock {
        padding: 0 20px;
        color: #f5e0dc;
        font-weight: 600;
        background-color: rgba(137, 180, 250, 0.15);
        border-radius: 8px;
        margin: 4px 0;
    }

    #battery,
    #network,
    #pulseaudio,
    #tray {
        padding: 0 12px;
        margin: 0 4px;
    }

    #battery {
        color: #a6e3a1;
    }

    #battery.charging {
        color: #a6e3a1;
    }

    #battery.warning:not(.charging) {
        color: #f9e2af;
        font-weight: 700;
    }

    #battery.critical:not(.charging) {
        color: #f38ba8;
        font-weight: 700;
    }

    #network {
        color: #89dceb;
    }

    #pulseaudio {
        color: #f5c2e7;
    }

    #pulseaudio.muted {
        color: #6c7086;
    }

    #tray {
        padding: 0 10px;
    }

    #custom-terminal {
        padding: 0 12px;
        margin: 0 4px;
        color: #89dceb;
        font-size: 16px;
    }

    #custom-power {
        padding: 0 15px;
        margin: 0 5px;
        color: #a6e3a1;
        font-size: 16px;
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
            configuration {
                modi: "drun,run,window";
                show-icons: true;
                drun-display-format: "{name}";
                font: "ZedMono Nerd Font 12";
            }

            @theme "/dev/null"

            * {
                bg: #1a1b26;
                bg-alt: #24283b;
                fg: #c0caf5;
                fg-alt: #a9b1d6;
                
                accent: #7aa2f7;
                urgent: #f7768e;
                
                background-color: transparent;
                text-color: @fg;
                
                margin: 0;
                padding: 0;
                spacing: 0;
            }

            window {
                background-color: @bg;
                border: 2px;
                border-color: @accent;
                border-radius: 12px;
                width: 500px;
                padding: 16px;
            }

            mainbox {
                children: [inputbar, listview];
                spacing: 16px;
            }

            inputbar {
                children: [entry];
                background-color: @bg-alt;
                border-radius: 8px;
                padding: 12px;
            }

            entry {
                placeholder: "";
            }

            listview {
                lines: 8;
                scrollbar: false;
            }

        element {
            padding: 8px 12px;
            border-radius: 6px;
            spacing: 16px;
        }

        element selected {
            background-color: @accent;
            text-color: @bg;
        }

        element-icon {
            size: 20px;
            margin: 0 16px 0 0;
        }

        element-text {
            vertical-align: 0.5;
        }
    EOF
                                    chown -R anupjsebastian:users "$ROFI_DIR"
  '';
}
