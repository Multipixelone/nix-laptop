{
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.pyprland = {
    Unit = {
      Description = "Pyprland daemon";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = lib.getExe pkgs.pyprland;
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
