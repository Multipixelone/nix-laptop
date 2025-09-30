{
  lib,
  pkgs,
  ...
}:
{
  systemd.user.services.pyprland = {
    Unit.Description = "pyprland plugin for hyprland";

    Install = {
      WantedBy = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = lib.getExe pkgs.pyprland;
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
