{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    stylix.url = "github:nix-community/stylix/release-25.05";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.starscream = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/starscream/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
        ./modules/nixos
      ];
    };
    homeManagerModules.default = ./modules/home-manager;
  };
}
