{ unstablePkgs, pkgs, ... }:
{
  # Install Synology Drive Client
  # Note: Synology Drive has built-in autostart, no systemd service needed
  environment.systemPackages = [
    unstablePkgs.synology-drive-client
  ];
}
