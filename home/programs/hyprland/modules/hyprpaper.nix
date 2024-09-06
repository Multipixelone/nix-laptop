{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  # TODO I really need to write this in a better way, but my laptop hates swww for some reason...
  wallpaper-set-link = pkgs.writeShellApplication {
    name = "wallpaper-set";
    runtimeInputs = [pkgs.swww];
    text = ''
      swww img -o DP-1 --transition-fps 240 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper}
      swww img -o DP-3 --transition-fps 60 --transition-type wave --transition-angle 120 --transition-step 30 ${config.theme.side-wallpaper}
    '';
  };
  wallpaper-set-zelda = pkgs.writeShellApplication {
    name = "wallpaper-set";
    runtimeInputs = [pkgs.wbg];
    text = ''
      wbg ${config.theme.wallpaper}
    '';
  };
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = [(lib.getExe wallpaper-set-link) (lib.getExe wallpaper-set-zelda)];
  };
  systemd.user.services.swww = lib.mkIf (osConfig.networking.hostName == "link") {
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
