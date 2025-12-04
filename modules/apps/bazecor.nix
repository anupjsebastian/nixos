{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.bazecor
  ];

  # Enable udev rules for Dygma keyboards
  services.udev.packages = [
    unstablePkgs.bazecor
  ];
}
