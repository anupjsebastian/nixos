{ pkgs, ... }:
{
  # Waybar configuration and styling
  config = builtins.toJSON {
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
      "custom/terminal"
      "pulseaudio"
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
      format = "";
      tooltip = false;
      on-click = "${pkgs.ptyxis}/bin/ptyxis --new-window";
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

  style = ''
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
    #tray,
    #custom-terminal {
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
        margin-right: 8px;
    }

    #custom-terminal {
        color: #89dceb;
    }

    #custom-power {
        padding: 0 15px;
        margin: 0 5px;
        color: #a6e3a1;
        font-size: 16px;
    }
  '';
}
