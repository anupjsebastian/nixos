{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.synology-drive-client
  ];

  # Auto-start Synology Drive on login
  systemd.user.services.synology-drive = {
    description = "Synology Drive Client";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${unstablePkgs.synology-drive-client}/bin/synology-drive";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}
