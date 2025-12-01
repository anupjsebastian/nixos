{
  description = "NixOS config for nyx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    try = {
      url = "github:tobi/try";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bitwig = {
      url = "github:polygon/audio.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      niri,
      noctalia,
      try,
      bitwig,
    }:
    let
      system = "x86_64-linux";

      # Desktop environment selector
      # Options: "niri" or "gnome"
      # Change this to switch desktops
      desktop = "niri";

      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
        overlays = [ bitwig.overlays.default ];
      };
      unstablePkgs = import nixpkgs-unstable {
        system = system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./hosts/nyx/configuration.nix

          # Home Manager integration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.anupjsebastian = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit
                noctalia
                niri
                unstablePkgs
                try
                desktop
                ;
            };
          }

          # Noctalia NixOS module
          noctalia.nixosModules.default
        ];
        specialArgs = {
          inherit
            noctalia
            niri
            unstablePkgs
            desktop
            bitwig
            ;
        };
      };
    };
}
