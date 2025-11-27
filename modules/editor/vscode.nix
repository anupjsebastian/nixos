{ unstablePkgs, ... }:
{
  environment.systemPackages = [
    (unstablePkgs.vscode.override {
      commandLineArgs = [
        "--ozone-platform-hint=auto"
      ];
    })
  ];
}
