{
  pkgs,
  config,
  lib,
  ...
}: let
  wallpaper-set = pkgs.writeShellApplication {
    name = "wallpaper-set";
    runtimeInputs = [pkgs.swww];
    text = ''
      # broken on zelda for some reason. swww freezes after the first frame
      # swww img -o eDP-1 --transition-fps 60 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper}
      swww img -o DP-1 --transition-fps 240 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper}
      swww img -o DP-3 --transition-fps 60 --transition-type wave --transition-angle 120 --transition-step 30 ${config.theme.side-wallpaper}
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
      ExecStart = lib.getExe' pkgs.swww "swww-daemon";
      ExecStop = "${lib.getExe pkgs.swww} kill";
      Restart = "always";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
