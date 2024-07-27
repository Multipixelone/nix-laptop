{
  pkgs,
  config,
  lib,
  ...
}: let
  swww = lib.getExe pkgs.swww;
  swww-daemon = pkgs.swww + "/bin/swww-daemon";
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "${swww} img -o DP-1 --transition-fps 240 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper}"
      "${swww} img -o DP-3 --transition-fps 60 --transition-type wave --transition-angle 120 --transition-step 30 ${config.theme.side-wallpaper}"
    ];
  };
  systemd.user.services.swww = {
    Unit = {
      Description = "swww wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${swww-daemon}";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
