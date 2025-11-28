{
  config,
  pkgs,
  noctalia,
  niri,
  unstablePkgs,
  try,
  ...
}:

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

  # Import module configurations
  imports = [
    noctalia.homeModules.default
    niri.homeModules.niri
    try.homeManagerModules.default
    ./modules/home/niri.nix
    ./modules/home/shell.nix
    ./modules/home/clipboard.nix
  ];

  # Configure try for temporary project directories
  programs.try = {
    enable = true;
    path = "~/.tries";
  };

  # GTK theme configuration
  gtk = {
    enable = true;
    theme = {
      name = "Tokyonight-Dark-BL";
      package = pkgs.tokyonight-gtk-theme;
    };
    iconTheme = {
      name = "Numix";
      package = pkgs.numix-icon-theme;
    };
  };

  # Force overwrite existing GTK config files
  xdg.configFile."gtk-3.0/settings.ini".force = true;
}
