{ pkgs, ... }:
{
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
