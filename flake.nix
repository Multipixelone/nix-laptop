{
  description = "Multipixelone (Finn)'s nix + HomeManager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nurpkgs.url = "github:nix-community/NUR";
    musnix.url = "github:musnix/musnix";
    stylix.url = "github:danth/stylix";
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-hardware.url = "github:NixOS/nixos-hardware/master";
    attic.url = "github:zhaofengli/attic";
    geospatial.url = "github:Multipixelone/geospatial-nix";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    secrets = {
      url = "git+ssh://git@github.com/Multipixelone/nix-secrets.git";
      flake = false;
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    umu = {
      url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs @ {
    nixpkgs,
    home-manager,
    nixos-hardware,
    stylix,
    agenix,
    chaotic,
    nur,
    ...
  }: {
    nixosConfigurations = {
      zelda = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/zelda.nix
          inputs.musnix.nixosModules.musnix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          chaotic.nixosModules.default
          nur.nixosModules.nur
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tunnel = import ./home/zelda.nix;
          }
        ];
      };
      kubenode1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/kubenode1.nix
          # inputs.musnix.nixosModules.musnix
          # inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          # agenix.nixosModules.default
          # chaotic.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tunnel = import ./home/server.nix;
          }
        ];
      };
      rpidns2 = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/rpidns2.nix
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {inherit inputs;};
            home-manager.users.tunnel = import ./home/server.nix;
          }
        ];
      };
      link = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./nixos/link.nix
          inputs.musnix.nixosModules.musnix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          inputs.attic.nixosModules.atticd
          agenix.nixosModules.default
          chaotic.nixosModules.default
          nur.nixosModules.nur
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
