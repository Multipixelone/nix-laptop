{ inputs, ... }:
{
  flake.modules = {
    nixos.gaming =
      { pkgs, ... }:
      {
        imports = [
          inputs.nix-gaming.nixosModules.wine
        ];
        programs.wine = {
          enable = true;
          # package = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-cachyos;
          package = pkgs.wine-staging;
          binfmt = true;
          ntsync = true;
        };

      };
    homeManager.gaming =
      { pkgs, ... }:
      {
        home.packages = [
          inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.winetricks-git
        ];
      };
  };
}
