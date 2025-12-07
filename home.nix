{
  config,
  pkgs,
  noctalia,
  niri,
  unstablePkgs,
  try,
  lib,
  desktop,
  ...
}:

let
  # Desktop choice comes from flake.nix
  # Conditional imports for desktop-specific modules
  desktopModules =
    if desktop == "niri" then
      [
        noctalia.homeModules.default
        niri.homeModules.niri
        ./modules/home/niri.nix
      ]
    else
      [ ];
in
{
  # Home Manager needs a bit of information about you and the paths it should manage
  home.username = "anupjsebastian";
  home.homeDirectory = "/home/anupjsebastian";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "25.05";

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Allow Home Manager to overwrite existing files
  home.activation = {
    removeExistingRofiConfig = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      rm -f ~/.config/rofi/config.rasi
    '';
  };

  # Import module configurations
  imports = [
    try.homeModules.default
    ./modules/home/shell.nix
    ./modules/home/clipboard.nix
    ./modules/home/thunar.nix
  ]
  ++ desktopModules;

  # Configure try for temporary project directories
  programs.try = {
    enable = true;
    path = "~/.tries";
  };

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
    font = {
      name = "Sans";
      size = 10;
    };
  };

  # Font settings via dconf
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "Sans 10";
      document-font-name = "Sans 10";
      monospace-font-name = "Monospace 10";
      text-scaling-factor = 1.0;
    };
  };
}
