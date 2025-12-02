{ pkgs, unstablePkgs, ... }:
{
  environment.systemPackages = [
    # Core Neovim
    unstablePkgs.neovim # Latest Neovim (0.11.4+)

    # Essential tools for plugins
    pkgs.git # Required for plugin management and gitsigns
    pkgs.ripgrep # Telescope searching, live grep
    pkgs.fd # Telescope file finding
    pkgs.fzf # Fuzzy finder integration

    # Git tools
    pkgs.lazygit # LazyGit TUI integration
    pkgs.delta # Better git diffs

    # Language servers and tools (Mason will also install these)
    pkgs.lua-language-server # Lua LSP for Neovim config
    pkgs.stylua # Lua formatter
    pkgs.nodePackages.bash-language-server # Bash LSP
    pkgs.nodePackages.typescript-language-server # TypeScript/JavaScript
    pkgs.nodePackages.vscode-langservers-extracted # HTML/CSS/JSON
    pkgs.nodePackages.prettier # Code formatter

    # Python support
    pkgs.python3 # Python runtime
    pkgs.python3Packages.pip # For installing Python tools
    pkgs.ruff # Python linter/formatter

    # Build tools for native plugins
    pkgs.gcc # C compiler for tree-sitter and native plugins
    pkgs.gnumake # Make for building plugins
    pkgs.cmake # CMake for some plugins
    pkgs.pkg-config # For finding libraries
    pkgs.unzip # For extracting archives

    # Runtime dependencies
    pkgs.nodejs # Node.js for Copilot and other plugins
    pkgs.nodePackages.npm # npm for strudel.nvim and other plugins
    pkgs.tree-sitter # Tree-sitter CLI

    # Clipboard support
    pkgs.xclip # X11 clipboard
    pkgs.wl-clipboard # Wayland clipboard

    # Additional utilities
    pkgs.bat # Better cat with syntax highlighting
    pkgs.eza # Better ls (used by some telescope extensions)
    pkgs.glibcLocales # Locale support
  ];

  # System-wide activation script to set up kickstart.nvim config
  system.activationScripts.neovimConfig = ''
    # Define paths
    NVIM_CONFIG_DIR="/home/anupjsebastian/.config/nvim"
    KICKSTART_REPO="https://github.com/anupjsebastian/kickstart.nvim.git"

    # Check if config already exists
    if [ ! -d "$NVIM_CONFIG_DIR" ]; then
      echo "Setting up Neovim configuration from kickstart.nvim..."
      
      # Ensure .config directory exists
      mkdir -p /home/anupjsebastian/.config
      chown anupjsebastian:users /home/anupjsebastian/.config
      
      # Clone the kickstart.nvim repository as the user
      if ${pkgs.su}/bin/su -c "${pkgs.git}/bin/git clone '$KICKSTART_REPO' '$NVIM_CONFIG_DIR'" anupjsebastian; then
        echo "Neovim configuration installed successfully. Run 'nvim' to complete plugin installation."
      else
        echo "Warning: Failed to clone kickstart.nvim. You can manually clone it later with:"
        echo "  git clone $KICKSTART_REPO $NVIM_CONFIG_DIR"
      fi
    else
      echo "Neovim configuration already exists at $NVIM_CONFIG_DIR"
    fi
  '';
}
