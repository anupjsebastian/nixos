{ pkgs, ... }:
let
  rofiTheme = pkgs.writeText "custom.rasi" ''
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
        width: 800px;
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
        lines: 20;
        scrollbar: false;
    }

    element {
        padding: 8px 12px;
        border-radius: 6px;
    }

    element selected {
        background-color: @accent;
        text-color: @bg;
    }

    element-icon {
        size: 20px;
        margin: 0 12px 0 0;
    }

    element-text {
        vertical-align: 0.5;
    }
  '';
in
{
  # Rofi configuration
  programs.rofi = {
    enable = true;
    theme = "${rofiTheme}";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
      drun-display-format = "{name}";
      font = "ZedMono Nerd Font 12";
    };
  };

  # Clipboard manager for Wayland with GUI
  home.packages = with pkgs; [
    cliphist # Clipboard history manager for Wayland
    wl-clipboard # Required by cliphist

    # Wrapper scripts for clipboard operations
    (pkgs.writeShellScriptBin "clipboard-history" ''
      ${pkgs.cliphist}/bin/cliphist list | ${pkgs.rofi}/bin/rofi -dmenu -p "Clipboard" | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy
    '')
    (pkgs.writeShellScriptBin "clipboard-clear" ''
      ${pkgs.cliphist}/bin/cliphist wipe
      ${pkgs.libnotify}/bin/notify-send "Clipboard" "History cleared"
    '')
  ];

  # Start cliphist daemon on login
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history service";
      After = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.writeShellScript "cliphist-daemon" ''
        ${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store &
        ${pkgs.wl-clipboard}/bin/wl-paste --type image --watch ${pkgs.cliphist}/bin/cliphist store
      ''}";
      Restart = "on-failure";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # Desktop entry for clipboard history
  home.file.".local/share/applications/clipboard-history.desktop".text = ''
    [Desktop Entry]
    Name=Clipboard History
    Comment=View and select from clipboard history
    Exec=clipboard-history
    Icon=edit-paste
    Type=Application
    Categories=Utility;
  '';
}
