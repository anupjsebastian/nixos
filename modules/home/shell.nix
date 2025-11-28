{ pkgs, ... }:

{
  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      # Add custom starship configuration here if needed
    };
  };

  # Yazi file manager
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  # CLI utilities
  home.packages = with pkgs; [
    fastfetch
    btop
  ];
}
