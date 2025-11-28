{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.dropbox
  ];
}
