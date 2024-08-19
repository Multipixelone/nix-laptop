{
  pkgs,
  config,
  lib,
  ...
}: let
  swww = lib.getExe pkgs.swww;
  swww-daemon = lib.getExe' pkgs.swww "swww-daemon";
  wallpaper-set = pkgs.writeShellApplication {
    name = "wallpaper-set";
    runtimeInputs = [pkgs.swww];
    text = ''
      swww img -o eDP-1 --transition-fps 60 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper} &> /dev/null
      swww img -o DP-1 --transition-fps 240 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper} &> /dev/null
      swww img -o DP-3 --transition-fps 60 --transition-type wave --transition-angle 120 --transition-step 30 ${config.theme.side-wallpaper} &> /dev/null
    '';
  };
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = [(lib.getExe wallpaper-set)];
  };
  systemd.user.services.swww = {
    Unit = {
      Description = "swww wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = swww-daemon;
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
