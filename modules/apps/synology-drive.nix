{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.synology-drive-client
  ];
}
