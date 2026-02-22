{
  nixpkgs.config.allowUnfreePackages = [ "zoom-us" ];
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.zoom-us
      ];
    };
}
