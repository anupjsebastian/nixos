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

  # Enable Yazi file manager
  programs.yazi = {
    enable = true;
  };

  # Configure bash for yazi integration
  programs.bash.interactiveShellInit = ''
    # Yazi shell wrapper for cd on exit
    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      IFS= read -r -d "" cwd < "$tmp"
      [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
      rm -f -- "$tmp"
    }
  '';

  # CLI utilities
  environment.systemPackages = with pkgs; [
    fastfetch
    btop
  ];
}
