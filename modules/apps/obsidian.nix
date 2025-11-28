{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.obsidian
  ];

  # Fix Obsidian Wayland support
  environment.etc."xdg/obsidian.desktop".text = ''
    [Desktop Entry]
    Name=Obsidian
    Exec=obsidian --ozone-platform=wayland --enable-features=UseOzonePlatform,WaylandWindowDecorations
    Icon=obsidian
    Type=Application
    Categories=Office;
  '';
}
