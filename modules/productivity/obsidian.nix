{
  nixpkgs.config.allowUnfreePackages = [ "obsidian" ];
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.obsidian
      ];
    };
}
