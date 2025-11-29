{ pkgs, ... }:

{
  # Bash shell configuration
  programs.bash = {
    enable = true;
    enableCompletion = true;

    # Yazi shell wrapper function to cd to the directory on exit
    initExtra = ''
      # VTE (GNOME Terminal/Ptyxis) integration for directory tracking
      if [ -f /etc/profile.d/vte.sh ]; then
        source /etc/profile.d/vte.sh
      elif [ -f ${pkgs.vte}/etc/profile.d/vte.sh ]; then
        source ${pkgs.vte}/etc/profile.d/vte.sh
      fi

      # Yazi function to change directory on exit
      function y() {
        local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
        yazi "$@" --cwd-file="$tmp"
        if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
          builtin cd -- "$cwd"
        fi
        rm -f -- "$tmp"
      }
    '';
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
