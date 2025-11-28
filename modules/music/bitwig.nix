{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.bitwig-studio
  ];
}
