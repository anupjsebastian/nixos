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
      outputs."HDMI-A-1" = {
        scale = 1.5;
        mode = {
          width = 3840;
          height = 2160;
          refresh = 120.0;
        };
      };

      # Thunderbolt dock DisplayPort (commented out - use if dock is stable)
      # outputs."DP-5" = {
      #   scale = 1.5;
      #   mode = {
      #     width = 3840;
      #     height = 2160;
      #     refresh = 240.0;
      #   };
      # };

      # Layout configuration
      layout = {
        gaps = 8;
        center-focused-column = "on-overflow";
        always-center-single-column = true;

        struts = {
          top = 1;
        };

        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
        ];

        default-column-width = {
          proportion = 0.5;
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

      # Enable XWayland for X11 applications
      prefer-no-csd = false;

      # Window rules
      window-rules = [
        # Default window rules for all windows
        {
          geometry-corner-radius = {
            top-left = 8.0;
            top-right = 8.0;
            bottom-left = 8.0;
            bottom-right = 8.0;
          };
          clip-to-geometry = true;
        }
        # Nautilus: always open at 40% width
        {
          matches = [
            { app-id = "^org\\.gnome\\.Nautilus$"; }
          ];
          default-column-width = {
            proportion = 0.4;
          };
        }
        # Thunar: always open at 40% width
        {
          matches = [
            { app-id = "^thunar$"; }
            { app-id = "^Thunar$"; }
          ];
          default-column-width = {
            proportion = 0.4;
          };
        }
        # VS Code: always open at 70% width
        {
          matches = [
            { app-id = "^code$"; }
            { app-id = "^Code$"; }
            { title = "^Visual Studio Code"; }
          ];
          default-column-width = {
            proportion = 0.7;
          };
        }
      ];

      # Screenshot configuration
      screenshot-path = "~/Pictures/Screenshots/screenshot_%Y-%m-%d_%H-%M-%S.png";

      # Animations
      animations = {
        slowdown = 0.8;
        workspace-switch.kind = {
          spring = {
            damping-ratio = 1.0;
            stiffness = 800;
            epsilon = 0.0001;
          };
        };
      };

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
          command = [ "xwayland-satellite" ];
        }

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
            "900"
            "niri msg action power-off-monitors"
            "timeout"
            "1800"
            "noctalia-shell ipc call lockScreen lock"
            "resume"
            "niri msg action power-on-monitors"
          ];
        }
      ];

      # Keybindings with Noctalia IPC integration
      binds = with config.lib.niri.actions; {
        # Noctalia integrations
        "Mod+Space".action.spawn = noctalia "launcher toggle";
        "Mod+P".action.spawn = noctalia "sessionMenu toggle";
        "Mod+E".action.spawn = noctalia "launcher emoji";
        "Mod+Shift+Return".action.spawn = [ "clipboard-history" ];
        "Mod+Shift+C".action.spawn = noctalia "launcher calculator";

        # Applications
        "Mod+Return".action.spawn = [
          "ptyxis"
          "--new-window"
        ];
        "Mod+B".action.spawn = [ "google-chrome-stable" ];
        "Mod+A".action.spawn = [
          "google-chrome-stable"
          "--app=https://chatgpt.com/"
        ];
        "Mod+M".action.spawn = [
          "google-chrome-stable"
          "--app=https://mail.notion.so"
        ];
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
        "Mod+N".action.spawn = [ "thunar" ];
        "Mod+Shift+P".action.spawn = [ "color-picker" ];

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

        # Window navigation (arrow keys)
        "Mod+Left".action."focus-column-left" = [ ];
        "Mod+Down".action."focus-window-down" = [ ];
        "Mod+Up".action."focus-window-up" = [ ];
        "Mod+Right".action."focus-column-right" = [ ];

        # Window movement (vim-style)
        "Mod+Shift+H".action."move-column-left" = [ ];
        "Mod+Shift+J".action."move-window-down" = [ ];
        "Mod+Shift+K".action."move-window-up" = [ ];
        "Mod+Shift+L".action."move-column-right" = [ ];

        # Window movement (arrow keys)
        "Mod+Shift+Left".action."move-column-left" = [ ];
        "Mod+Shift+Down".action."move-window-down" = [ ];
        "Mod+Shift+Up".action."move-window-up" = [ ];
        "Mod+Shift+Right".action."move-column-right" = [ ];

        # Workspace navigation
        "Mod+I".action."focus-workspace-down" = [ ];
        "Mod+O".action."focus-workspace-up" = [ ];
        "Mod+Page_Down".action."focus-workspace-down" = [ ];
        "Mod+Page_Up".action."focus-workspace-up" = [ ];

        # Move window to workspace up/down
        "Mod+Shift+I".action."move-column-to-workspace-down" = [ ];
        "Mod+Shift+O".action."move-column-to-workspace-up" = [ ];
        "Mod+Shift+Page_Down".action."move-column-to-workspace-down" = [ ];
        "Mod+Shift+Page_Up".action."move-column-to-workspace-up" = [ ];

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
        "Mod+Escape".action."toggle-overview" = [ ];
        "Mod+Backslash".action."toggle-overview" = [ ];

        # System controls
        "Mod+Shift+E".action."power-off-monitors" = [ ];
        "Mod+Shift+M".action."power-on-monitors" = [ ];

        # Volume (using Noctalia IPC for OSD)
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";

        # Brightness (using Noctalia IPC for OSD)
        "XF86MonBrightnessUp".action.spawn = noctalia "brightness increase";
        "XF86MonBrightnessDown".action.spawn = noctalia "brightness decrease";

        # Brightness (Custom Keymap)
        "Mod+Ctrl+Alt+Right".action.spawn = noctalia "brightness increase";
        "Mod+Ctrl+Alt+Left".action.spawn = noctalia "brightness decrease";
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
      network.wifiEnabled = false;

      general = {
        animationDisabled = false;
        animationSpeed = 2.0;
      };

      ui = {
        fontDefault = "Roboto";
        fontFixed = "DejaVu Sans Mono";
        fontDefaultScale = 1.10;
        fontFixedScale = 1.10;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 1;
        panelsAttachedToBar = true;
        settingsPanelAttachToBar = true;
      };

      systemMonitor = {
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        tempWarningThreshold = 80;
        tempCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        diskWarningThreshold = 80;
        diskCriticalThreshold = 90;
        cpuPollingInterval = 2000;
        tempPollingInterval = 2000;
        memPollingInterval = 2000;
        diskPollingInterval = 3000;
        networkPollingInterval = 2000;
        useCustomColors = false;
        warningColor = "";
        criticalColor = "";
      };

      sessionMenu = {
        enableCountdown = true;
        countdownDuration = 10000;
        position = "top_right";
        showHeader = true;
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = false;
          }
          {
            action = "hibernate";
            enabled = false;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
          {
            action = "logout";
            enabled = false;
          }
        ];
      };

      bar = {
        position = "top";
        density = "comfortable";
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
            { id = "Taskbar"; }
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
            {
              id = "SystemMonitor";
              showMemoryAsPercent = true;
              showDiskUsage = true;
              diskPath = "/";
            }
            { id = "Tray"; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "WiFi"; }
            { id = "Bluetooth"; }
            { id = "NotificationHistory"; }
            { id = "ControlCenter"; }
          ];
        };
      };

      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = true;
      };

      colorSchemes = {
        useWallpaperColors = false;
        predefinedScheme = "Tokyo Night";
        darkMode = true;
        schedulingMode = "off";
        manualSunrise = "05:30";
        manualSunset = "17:30";
        matugenSchemeType = "scheme-fruit-salad";
        generateTemplatesForPredefined = true;
      };

      appLauncher = {
        enableClipboardHistory = false;
        enableClipPreview = false;
      };

      location = {
        name = "Houston";
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = true;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = false;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = -1;
      };
    };
  };

  # Additional packages for the desktop
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    swayidle
    networkmanagerapplet
    tokyonight-gtk-theme
    xwayland-satellite

    # Color picker with desktop entry
    (pkgs.writeShellScriptBin "color-picker" ''
      ${pkgs.hyprpicker}/bin/hyprpicker -a
    '')
  ];

  # Desktop entry for color picker
  home.file.".local/share/applications/color-picker.desktop".text = ''
    [Desktop Entry]
    Name=Color Picker
    Comment=Pick colors from the screen
    Exec=color-picker
    Icon=gtk-select-color
    Type=Application
    Categories=Utility;Graphics;
  '';
}
