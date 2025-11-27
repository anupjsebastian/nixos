{ unstablePkgs, pkgs, ... }:
{
  environment.systemPackages = [
    unstablePkgs.neovim # Latest Neovim
    pkgs.git # Essential for plugins
    pkgs.ripgrep # Telescope, searching
    pkgs.fd # Telescope, searching
    pkgs.lazygit # For lazygit plugin
    pkgs.nodejs # Node.js plugins (snacks, noice, etc.)
    pkgs.python3 # Python plugins
    pkgs.lua # Lua plugins
    pkgs.gcc # For building native plugins
    pkgs.cmake # For building native plugins
    pkgs.xclip # Clipboard support
    pkgs.fzf # Fuzzy finder
    pkgs.bat # Pretty file viewer
    pkgs.gnupg # For GPG support
    pkgs.unzip # For plugin installation
    pkgs.tree-sitter # Syntax highlighting
    pkgs.glibcLocales # Locale support
  ];
}
