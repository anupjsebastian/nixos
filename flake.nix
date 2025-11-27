{
  description = "NixOS config for nyx";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # You can add more inputs later (home-manager, nixvim, etc.)
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      unstablePkgs = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.nyx = nixpkgs.lib.nixosSystem {
        inherit pkgs;
        modules = [
          ./hosts/nyx/configuration.nix
        ];
        specialArgs = {
          inherit unstablePkgs;
        };
      };
    };
}
