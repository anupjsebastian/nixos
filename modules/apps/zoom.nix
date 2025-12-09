{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.zoom-us
  ];

}
