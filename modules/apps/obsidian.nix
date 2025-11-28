{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.obsidian
  ];
}
