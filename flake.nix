{
  description = "Multipixelone (Finn)'s nix + HomeManager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable-small";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    # use lix (failing build only on one computer?)
    # lix = {
    #   url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # nixpkgs for zoom screensharing
    flake-utils.url = "github:numtide/flake-utils";
    gvolpe-zoom.url = "github:gvolpe/nix-config";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    yabridge-wine.url = "git+https://github.com/nixos/nixpkgs?rev=0e82ab234249d8eee3e8c91437802b32c74bb3fd";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    jovian.url = "github:Jovian-Experiments/Jovian-NixOS";
    nurpkgs.url = "github:nix-community/NUR";
    musnix.url = "github:musnix/musnix";
    catppuccin.url = "github:catppuccin/nix";
    nix-hardware.url = "github:NixOS/nixos-hardware/master";
    zjstatus.url = "github:dj95/zjstatus";
    helix.url = "github:helix-editor/helix";
    yazi.url = "github:sxyazi/yazi";
    nixcord.url = "github:kaylorben/nixcord";
    geospatial.url = "github:imincik/geospatial-nix";
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    ucodenix.url = "github:e-tho/ucodenix";
    base16.url = "github:SenchoPens/base16.nix";
    blocklist = {
      url = "github:StevenBlack/hosts";
      flake = false;
    };
    photogimp = {
      url = "github:Diolinux/PhotoGIMP";
      flake = false;
    };
    better-fox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    secrets = {
      url = "git+ssh://git@github.com/Multipixelone/nix-secrets.git";
      flake = false;
    };
    nextmeeting = {
      url = "github:Multipixelone/nextmeeting/reformat?dir=packaging";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    waybar-mediaplayer = {
      url = "github:Multipixelone/waybar-mediaplayer/artist";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    # TODO switch to upstream if PR accepted (https://github.com/obskyr/khinsider/pull/98)
    khinsider = {
      url = "github:Multipixelone/khinsider/nix-build";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    humble-key = {
      url = "github:Multipixelone/humble-steam-key-redeemer/nix-build";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    qtscrob = {
      url = "github:Multipixelone/QtScrobbler/nix-build";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.base16.follows = "base16";
    };
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
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
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # umu = {
    #   url = "git+https://github.com/LovingMelody/umu-launcher/?dir=packaging\/nix&submodules=1&ref=update-nix-package";
    #   # url = "git+https://github.com/Open-Wine-Components/umu-launcher/?dir=packaging\/nix&submodules=1";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # hyprland wm
    hyprland.url = "github:hyprwm/hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hypr-binds = {
      url = "github:hyprland-community/hypr-binds";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    agenix,
    chaotic,
    nur,
    ...
  } @ inputs: let
    inherit (self) outputs;
    # Supported systems for your flake packages, shell, etc.
    systems = [
      "aarch64-linux"
      "i686-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    # This is a function that generates an attribute by calling a function you
    # pass to it, with each system as an argument
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    nixosConfigurations = {
      minish = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/minish.nix
          home-manager.nixosModules.home-manager
          inputs.stylix.nixosModules.stylix
          agenix.nixosModules.default
          chaotic.nixosModules.default
          nur.modules.nixos.default
          inputs.nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.tunnel = import ./home/zelda.nix;
          }
        ];
      };
      zelda = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./nixos/zelda.nix
          inputs.musnix.nixosModules.musnix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          chaotic.nixosModules.default
          nur.modules.nixos.default
          # inputs.lix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.tunnel = import ./home/zelda.nix;
          }
        ];
      };
      link = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./nixos/link.nix
          inputs.musnix.nixosModules.musnix
          inputs.stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
          chaotic.nixosModules.default
          nur.modules.nixos.default
          # inputs.lix.nixosModules.default
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              inherit inputs;
            };
            home-manager.users.tunnel = import ./home/link.nix;
          }
        ];
      };
    };
  };
}
