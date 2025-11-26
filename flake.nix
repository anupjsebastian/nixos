{
  description = "NixOS config for nyx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # You can add more inputs later (home-manager, nixvim, etc.)
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nyx/configuration.nix
          ./hosts/nyx/hardware-configuration.nix
        ];
      };
    };
}

