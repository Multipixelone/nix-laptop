{
  description = "Multipixelone (Finn)'s nix + HomeManager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    musnix = {url = "github:musnix/musnix";};
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-generators,
    nixos-hardware,
    stylix,
    nixvim,
    nix-index-database,
    ...
  }: {
    nixosConfigurations = {
      zelda = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/configuration.nix
          inputs.musnix.nixosModules.musnix
          nixos-hardware.nixosModules.dell-xps-15-9560
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tunnel = import ./home/zelda.nix;
          }
        ];
      };
      link = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/configuration.nix
          inputs.musnix.nixosModules.musnix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tunnel = import ./home/link.nix;
          }
        ];
      };
    };
  };
}
