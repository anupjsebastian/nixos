{ pkgs, unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.rustup
  ];
}
