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
    inherit (import mod) desktop laptop;

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
          #inputs.nur.modules.nixos.default
        ];
    };

    minish = nixosSystem {
      inherit specialArgs;
      modules = [
        ./minish
        "${mod}/core/users.nix"
        "${mod}/nix"
        "${mod}/programs/fish.nix"
        "${mod}/programs/home-manager.nix"
        {
          home-manager = {
            users.tunnel.imports = homeImports.server;
            extraSpecialArgs = specialArgs;
            backupFileExtension = ".hm-backup";
          };
        }
      ];
    };
  };
}
