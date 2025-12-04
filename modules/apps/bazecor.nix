{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.bazecor
  ];
}
