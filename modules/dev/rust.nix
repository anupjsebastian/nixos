{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.rustc
  ];
}
