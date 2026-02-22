{ lib, ... }:
{
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
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
