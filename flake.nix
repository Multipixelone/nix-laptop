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
            pkgs.npins
            inputs.agenix.packages.${pkgs.system}.default
          ];
          name = "dots";
          DIRENV_LOG_FORMAT = "";
          shellHook = ''
            ${config.pre-commit.installationScript}
          '';
        };

        pre-commit.settings = {
          hooks = let
            # probably a better way to do this
            excludes = ["npins"];
          in {
            alejandra = {
              inherit excludes;
              enable = true;
            };
          };
        };

        formatter = pkgs.alejandra;
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-cloudflared.url = "github:wrbbz/nixpkgs/cloudflared-2025.4.0";

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
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    ucodenix.url = "github:e-tho/ucodenix";
    base16.url = "github:SenchoPens/base16.nix";
    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-emoji = {
      url = "github:samuelngs/apple-emoji-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blocklist = {
      url = "github:StevenBlack/hosts";
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
    beets-plugins = {
      url = "github:Multipixelone/beets-plugins";
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
    zjstatus-hints = {
      url = "github:Multipixelone/zjstatus-hints/nix-build";
      # inputs.nixpkgs.follows = "zjstatus";
      # inputs.crane.follows = "zjstatus";
      # inputs.rust-overlay.follows = "zjstatus";
    };
    # humble-key = {
    #   url = "github:Multipixelone/humble-steam-key-redeemer/nix-build";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
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
    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
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
      inputs.systems.follows = "systems";
    };
    anyrun-nixos-options = {
      url = "github:n3oney/anyrun-nixos-options";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };
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
