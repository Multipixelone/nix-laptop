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
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        settings = {
          program_options = {
            file_manager = lib.getExe pkgs.mimeo;
          };
        };
        tray = "auto";
      };
    };
}
