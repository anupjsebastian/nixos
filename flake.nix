{
  description = "NixOS config for nyx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # You can add more inputs later (home-manager, nixvim, etc.)
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/nyx/configuration.nix
        ];
        specialArgs = {
          nixpkgs-unstable = nixpkgs-unstable;
          system = system;
        };
      };
    };
}
