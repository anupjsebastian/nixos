{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.ticktick
  ];

}
