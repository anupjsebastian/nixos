{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.bitwig-studio
  ];
}
