{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    (unstablePkgs.vscode.override {
      commandLineArgs = [
        "--ozone-platform=wayland"
      ];
    })
  ];
}
