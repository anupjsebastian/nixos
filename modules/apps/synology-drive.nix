{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.synology-drive-client
  ];

  # Enable autostart for Synology Drive
  environment.etc."xdg/autostart/synology-drive.desktop".source =
    "${unstablePkgs.synology-drive-client}/share/applications/synology-drive.desktop";
}
