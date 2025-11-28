{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Helper function to create Noctalia IPC commands as lists
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (lib.splitString " " cmd);
in
{
  programs.niri = {
    settings = {
      # Input configuration
      input = {
        keyboard.xkb.layout = "us";

        touchpad = {
          tap = true;
          natural-scroll = true;
          accel-speed = 0.3;
        };

        mouse = {
          natural-scroll = true;
          accel-speed = 0.2;
        };
      };

      # Cursor configuration
      cursor = {
        theme = "Adwaita";
        size = 24;
      };

      # Output/display configuration
      outputs."DP-5" = {
        scale = 1.5;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 240.0;
        };
      };

      # Layout configuration
      layout = {
        gaps = 8;
        center-focused-column = "always";

        struts = {
          top = 1;
        };

        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width = {
          proportion = 0.6;
        };

        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#7aa2f7";
          inactive.color = "#3b4261";
        };

        border = {
          enable = false;
          width = 2;
          active.color = "#7aa2f7";
          inactive.color = "#3b4261";
        };

        # Disable tab indicator (using Noctalia bar for workspace indication)
        tab-indicator = {
          enable = true;
          place-within-column = true;
        };
      };

      # prefer-no-csd = true;

      # Window rules
      window-rules = [
        {
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
          clip-to-geometry = true;
        }
      ];

      # Screenshot configuration
      screenshot-path = "~/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

      # Animations
      animations.slowdown = 0.8;
      animations.workspace-switch.enable = false;

      # Overview - disable workspace previews
      overview = {
        backdrop-color = "#1a1b26"; # Match Tokyo Night background
        workspace-shadow.enable = false;
      };

      # Hotkey overlay
      hotkey-overlay.skip-at-startup = true;

      # Startup applications
      spawn-at-startup = [
        {
          command = [
            "nm-applet"
            "--indicator"
          ];
        }
        {
          command = [
            "swayidle"
            "-w"
            "timeout"
            "300"
            "niri"
            "msg"
            "action"
            "power-off-monitors"
            "resume"
            "niri"
            "msg"
            "action"
            "power-on-monitors"
          ];
        }
      ];

      # Keybindings with Noctalia IPC integration
      binds = with config.lib.niri.actions; {
        # Noctalia integrations
        "Mod+Space".action.spawn = noctalia "launcher toggle";
        "Mod+Escape".action.spawn = noctalia "lockScreen toggle";
        "Mod+P".action.spawn = noctalia "sessionMenu toggle";

        # Applications
        "Mod+Return".action.spawn = [
          "ptyxis"
          "--new-window"
        ];
        "Mod+B".action.spawn = [ "google-chrome-stable" ];
        "Mod+T".action.spawn = [
          "ptyxis"
          "-e"
          "btop"
        ];
        "Mod+Y".action.spawn = [
          "ptyxis"
          "-e"
          "yazi"
        ];
        "Mod+N".action.spawn = [ "nautilus" ];

        "Mod+Shift+Slash".action."show-hotkey-overlay" = [ ];

        # Window management
        "Mod+Q".action."close-window" = [ ];

        # Column/Window resizing
        "Mod+R".action."switch-preset-column-width" = [ ];
        "Mod+Shift+R".action."switch-preset-window-height" = [ ];
        "Mod+Ctrl+R".action."reset-window-height" = [ ];
        "Mod+F".action."maximize-column" = [ ];
        "Mod+Shift+F".action."fullscreen-window" = [ ];

        # Screenshots
        "Print".action.screenshot = { };
        "Ctrl+Print".action.screenshot-screen = { };
        "Alt+Print".action.screenshot-window = { };

        # Window navigation (vim-style)
        "Mod+H".action."focus-column-left" = [ ];
        "Mod+J".action."focus-window-down" = [ ];
        "Mod+K".action."focus-window-up" = [ ];
        "Mod+L".action."focus-column-right" = [ ];

        # Window movement
        "Mod+Shift+H".action."move-column-left" = [ ];
        "Mod+Shift+J".action."move-window-down" = [ ];
        "Mod+Shift+K".action."move-window-up" = [ ];
        "Mod+Shift+L".action."move-column-right" = [ ];

        # Workspace navigation
        "Mod+U".action."focus-workspace-down" = [ ];
        "Mod+I".action."focus-workspace-up" = [ ];
        "Mod+Page_Down".action."focus-workspace-down" = [ ];
        "Mod+Page_Up".action."focus-workspace-up" = [ ];

        # Move window to workspace up/down
        "Mod+Ctrl+U".action."move-column-to-workspace-down" = [ ];
        "Mod+Ctrl+I".action."move-column-to-workspace-up" = [ ];
        "Mod+Ctrl+Page_Down".action."move-column-to-workspace-down" = [ ];
        "Mod+Ctrl+Page_Up".action."move-column-to-workspace-up" = [ ];

        # Workspace switching
        "Mod+1".action."focus-workspace" = 1;
        "Mod+2".action."focus-workspace" = 2;
        "Mod+3".action."focus-workspace" = 3;
        "Mod+4".action."focus-workspace" = 4;
        "Mod+5".action."focus-workspace" = 5;
        "Mod+6".action."focus-workspace" = 6;
        "Mod+7".action."focus-workspace" = 7;
        "Mod+8".action."focus-workspace" = 8;
        "Mod+9".action."focus-workspace" = 9;

        # Move window to workspace
        "Mod+Shift+1".action."move-column-to-workspace" = 1;
        "Mod+Shift+2".action."move-column-to-workspace" = 2;
        "Mod+Shift+3".action."move-column-to-workspace" = 3;
        "Mod+Shift+4".action."move-column-to-workspace" = 4;
        "Mod+Shift+5".action."move-column-to-workspace" = 5;
        "Mod+Shift+6".action."move-column-to-workspace" = 6;
        "Mod+Shift+7".action."move-column-to-workspace" = 7;
        "Mod+Shift+8".action."move-column-to-workspace" = 8;
        "Mod+Shift+9".action."move-column-to-workspace" = 9;

        # Column width adjustment
        "Mod+Comma".action."set-column-width" = "-10%";
        "Mod+Period".action."set-column-width" = "+10%";

        # Consume/expel windows
        "Mod+BracketLeft".action."consume-or-expel-window-left" = [ ];
        "Mod+BracketRight".action."consume-or-expel-window-right" = [ ];

        # Floating/tiling toggle
        "Mod+V".action."toggle-window-floating" = [ ];
        "Mod+Shift+V".action."switch-focus-between-floating-and-tiling" = [ ];

        # Center column
        "Mod+C".action."center-column" = [ ];

        # Overview
        "Mod+O".action."toggle-overview" = [ ];

        # System - use loginctl to properly terminate the session
        "Mod+Shift+E".action.spawn = [
          "loginctl"
          "terminate-session"
          ""
        ];
        "Mod+Shift+P".action."power-off-monitors" = [ ];

        # Volume (using Noctalia IPC for OSD)
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";

        # Brightness (using Noctalia IPC for OSD)
        "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
        "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";
      };
    };
  };

  # Enable Noctalia shell with systemd service
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;

    # Noctalia settings with Tokyo Night theme
    settings = {
      dock.enabled = false;

      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "center";
        showHeader = true;
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = false;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
      };

      bar = {
        position = "top";
        density = "default";
        showCapsule = true;
        exclusiveZone = true;
        floating = true;
        widgets = {
          left = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
            { id = "ActiveWindow"; }
          ];
          center = [
            {
              id = "Clock";
              formatHorizontal = "MMM dd HH:mm";
              useMonospacedFont = true;
            }
          ];
          right = [
            { id = "SystemMonitor"; }
            { id = "Tray"; }
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "NotificationHistory"; }
            { id = "ControlCenter"; }
          ];
        };
      };
    };

    # Tokyo Night color scheme for Noctalia
    colors = {
      mError = "#f7768e";
      mOnError = "#1a1b26";
      mOnPrimary = "#1a1b26";
      mOnSecondary = "#1a1b26";
      mOnSurface = "#c0caf5";
      mOnSurfaceVariant = "#a9b1d6";
      mOnTertiary = "#1a1b26";
      mOnHover = "#c0caf5";
      mOutline = "#565f89";
      mPrimary = "#7aa2f7";
      mSecondary = "#bb9af7";
      mShadow = "#000000";
      mSurface = "#1a1b26";
      mHover = "#24283b";
      mSurfaceVariant = "#24283b";
      mTertiary = "#7dcfff";
    };
  };

  # Additional packages for the desktop
  home.packages = with pkgs; [
    wl-clipboard
    swayidle
    networkmanagerapplet
    hyprpicker
    tokyonight-gtk-theme
    papirus-icon-theme
  ];
}
