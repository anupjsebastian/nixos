{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.google-chrome
  ];
}
