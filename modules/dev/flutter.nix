{
  pkgs,
  unstablePkgs,
  ...
}:
{
  # Flutter development environment
  # Using Nix-provided Flutter (patched for NixOS compatibility)
  # For Chrome and Linux desktop targets

  environment.systemPackages = with pkgs; [
    # Flutter SDK from unstable (patched for NixOS)
    unstablePkgs.flutter

    # Chrome for Flutter web development
    google-chrome

    # Git (required by Flutter)
    git

    # Mesa utilities for Linux desktop OpenGL
    mesa-demos

    # Build tools for Linux desktop Flutter apps
    clang
    cmake
    ninja
    pkg-config
    gtk3
    glib
    pcre2
    libepoxy
  ];

  # Environment variables for Flutter
  environment.sessionVariables = {
    # Chrome executable for Flutter web
    CHROME_EXECUTABLE = "${pkgs.google-chrome}/bin/google-chrome-stable";
  };

  # Enable OpenGL for Flutter Linux desktop target
  hardware.graphics.enable = true;
}
