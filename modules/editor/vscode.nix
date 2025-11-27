{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.vscode
  ];
}
