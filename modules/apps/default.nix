{
  nixpkgs.config.allowUnfreePackages = [ "objectbox-linux" ];
  flake.modules.homeManager.gui =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        moonlight-qt
        piper
        waypipe
        filezilla
        bluebubbles
        gimp
      ];
    };
}
