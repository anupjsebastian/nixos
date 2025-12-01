{ pkgs, bitwig, ... }:
{
  # Bitwig Studio - Digital Audio Workstation
  environment.systemPackages = [
    bitwig.packages.${pkgs.system}.bitwig-studio6-latest
  ];
}
