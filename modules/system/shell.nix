{ pkgs, ... }:
{
  # Enable Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      # Add custom starship configuration here if needed
      # Example:
      # add_newline = false;
      # character = {
      #   success_symbol = "[➜](bold green)";
      #   error_symbol = "[➜](bold red)";
      # };
    };
  };
}
