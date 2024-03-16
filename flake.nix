{
  description = "Will's OS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware/b006ec52fce23b1d57f6ab4a42d7400732e9a0a2";
    rust-overlay.url = "github:oxalica/rust-overlay/e36f66bb10b09f5189dc3b1706948eaeb9a1c555";
  };

  outputs = inputs@{
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      will-pc = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              users.will = import ./will/home.nix;
              extraSpecialArgs = { inherit inputs; };
            };
          }
        ];
      };
    };
  };
}
