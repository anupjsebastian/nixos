{ pkgs, ... }:
{
  # Ruby development environment
  # Provides Ruby, Bundler, and essential build dependencies for native gem extensions

  environment.systemPackages = with pkgs; [
    # Ruby and package manager
    ruby_3_3
    bundler

    # Build tools (required for native gem extensions)
    gcc
    gnumake
    pkg-config

    # Essential libraries (most gems need these)
    zlib
    openssl
    libffi
    libyaml
    readline

    # JavaScript runtime (Rails asset pipeline, webpacker, etc.)
    nodejs
    yarn

    # Version control
    git

    # Database clients (add as needed)
    sqlite
    postgresql # For pg gem

    # Image processing (for ActiveStorage, image gems)
    imagemagick

    # Ruby development tools
    rubyPackages.solargraph # LSP for editor support
    rubyPackages.rubocop # Linting/formatting
  ];

  # Optional: Enable PostgreSQL service
  # Uncomment if you need a local PostgreSQL database
  # services.postgresql = {
  #   enable = true;
  #   ensureDatabases = [ "myapp_development" ];
  #   ensureUsers = [{
  #     name = "anupjsebastian";
  #     ensureDBOwnership = true;
  #   }];
  # };
}
