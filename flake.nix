{
  description = "Multipixelone (Finn)'s nix + HomeManager config";

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];

      imports = [
        ./hosts
        ./pkgs
        inputs.pre-commit-hooks.flakeModule
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.alejandra
            pkgs.just
            pkgs.attic-client
            inputs.agenix.packages.${pkgs.system}.default
          ];
          name = "dots";
          DIRENV_LOG_FORMAT = "";
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        pre-commit.settings = {
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
            nil.enable = true;
            deadnix.enable = true;
          };
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-cloudflared.url = "github:wrbbz/nixpkgs/cloudflared-2025.4.0";
    yabridge-wine.url = "git+https://github.com/nixos/nixpkgs?rev=0e82ab234249d8eee3e8c91437802b32c74bb3fd";

    # nixpkgs for zoom screensharing
    systems.url = "github:nix-systems/default-linux";

    flake-compat.url = "github:edolstra/flake-compat";

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nur.url = "github:nix-community/NUR";
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
    playlist-download = {
      url = "github:Multipixelone/playlist-downloader";
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
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
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
        systems.follows = "systems";
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
        hyprgraphics.follows = "hyprland/hyprgraphics";
        hyprlang.follows = "hyprland/hyprlang";
        hyprutils.follows = "hyprland/hyprutils";
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        hyprgraphics.follows = "hyprland/hyprgraphics";
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
}
