# Placeholder for python module
{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    # UV manages all python versions and tooling for development
    unstablePkgs.uv
  ];
}
