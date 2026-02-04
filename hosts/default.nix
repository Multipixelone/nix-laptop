{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations =
    let
      # shorten paths
      inherit (inputs.nixpkgs.lib) nixosSystem;

      homeImports = import "${self}/home/profiles";

      mod = "${self}/system";
      # get the basic config to build on top of
      inherit (import mod) desktop laptop server;
      replaceStdenvModule = {
        nixpkgs.config.replaceStdenv = { pkgs }: _oldStdenv: pkgs.stdenv;
      };

      # get these into the module system
      specialArgs = { inherit inputs self; };
    in
    {
      link = nixosSystem {
        inherit specialArgs;
        modules = desktop ++ [
          ./link

          "${mod}/programs/gamemode.nix"
          "${mod}/programs/gamestream.nix"
          "${mod}/programs/games.nix"

          "${mod}/services/minecraft-server.nix"

          "${mod}/programs/media.nix"
          "${mod}/services/jdownloader.nix"
          "${mod}/services/slskd.nix"
          "${mod}/services/calibre.nix"
          "${mod}/services/asf.nix"

          "${mod}/hardware/rgb.nix"
          "${mod}/hardware/ucode.nix"
          "${mod}/hardware/secure-boot.nix"

          "${mod}/network/cloudflared.nix"
          "${mod}/network/dnscrypt.nix"
          "${mod}/network/duckdns.nix"
          "${mod}/network/nas.nix"

          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.tunnel.imports = homeImports."tunnel@link";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
          inputs.musnix.nixosModules.musnix
          inputs.quadlet-nix.nixosModules.quadlet
          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.nur.modules.nixos.default
          replaceStdenvModule
        ];
      };

      zelda = nixosSystem {
        inherit specialArgs;
        modules = laptop ++ [
          ./zelda

          "${mod}/programs/media.nix"
          "${mod}/services/jdownloader.nix"

          "${mod}/network/dnscrypt.nix"
          "${mod}/hardware/secure-boot.nix"

          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.tunnel.imports = homeImports."tunnel@zelda";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
          inputs.musnix.nixosModules.musnix
          inputs.lanzaboote.nixosModules.lanzaboote
          inputs.quadlet-nix.nixosModules.quadlet
          inputs.agenix.nixosModules.default
          inputs.chaotic.nixosModules.default
          inputs.nur.modules.nixos.default
          replaceStdenvModule
        ];
      };

      minish = nixosSystem {
        inherit specialArgs;
        modules = desktop ++ [
          ./minish
          "${mod}/programs/nix-ld.nix"

          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.tunnel.imports = homeImports.server;
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
          inputs.agenix.nixosModules.default
          inputs.quadlet-nix.nixosModules.quadlet
          inputs.chaotic.nixosModules.default
          inputs.musnix.nixosModules.musnix
          inputs.nur.modules.nixos.default
          replaceStdenvModule
        ];
      };

      marin = nixosSystem {
        inherit specialArgs;
        modules = server ++ [
          ./marin
          "${mod}/services/minecraft-server.nix"

          "${mod}/programs/home-manager.nix"
          {
            home-manager = {
              users.tunnel.imports = homeImports."tunnel@marin";
              extraSpecialArgs = specialArgs;
              backupFileExtension = ".hm-backup";
            };
          }
          inputs.agenix.nixosModules.default
          inputs.quadlet-nix.nixosModules.quadlet
          inputs.chaotic.nixosModules.default
          replaceStdenvModule
        ];
      };
    };
}
