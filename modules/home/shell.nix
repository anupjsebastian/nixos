{ pkgs, ... }:

{
  # Bash shell configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
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
