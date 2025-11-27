{ pkgs, unstablePkgs, ... }:
{
  # Web development environment
  # Bun for JavaScript/TypeScript runtime and package management
  # Use Bun to install project-specific tools (Svelte, Firebase, Supabase, etc.)

  environment.systemPackages = with pkgs; [
    # JavaScript runtime and package manager
    unstablePkgs.bun

    # Git (version control)
    git
  ];

  # Environment variables for web development
  environment.sessionVariables = {
    # Bun will use this for global installs
    BUN_INSTALL = "$HOME/.bun";
  };

  # Add Bun global bin to PATH
  programs.bash.interactiveShellInit = ''
    export PATH="$HOME/.bun/bin:$PATH"
  '';

  programs.zsh.interactiveShellInit = ''
    export PATH="$HOME/.bun/bin:$PATH"
  '';
}
