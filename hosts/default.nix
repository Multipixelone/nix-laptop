{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations = let
    # shorten paths
    inherit (inputs.nixpkgs.lib) nixosSystem;

    homeImports = import "${self}/home/profiles";

    mod = "${self}/system";
    # get the basic config to build on top of
    inherit (import mod) desktop laptop server;

    # get these into the module system
    specialArgs = {inherit inputs self;};
  in {
    link = nixosSystem {
      inherit specialArgs;
      modules =
        desktop
        ++ [
          ./link

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/gamestream.nix"
          "${mod}/programs/games.nix"
          "${mod}/services/jdownloader.nix"
          "${mod}/services/slskd.nix"

          "${mod}/hardware/rgb.nix"
          "${mod}/hardware/ucode.nix"

          "${mod}/network/cloudflared.nix"
          "${mod}/network/dnscrypt.nix"
          "${mod}/network/duckdns.nix"

          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.tunnel.imports = homeImports."tunnel@link";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
          inputs.musnix.nixosModules.musnix
          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.nur.modules.nixos.default
        ];
    };

    minish = nixosSystem {
      inherit specialArgs;
      modules =
        server
        ++ [
          ./minish
          "${mod}/programs/nix-ld.nix"

          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.tunnel.imports = homeImports."tunnel@minish";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
        ];
    };
  };
}
