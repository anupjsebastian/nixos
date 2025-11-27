{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.rustup
  ];
}
