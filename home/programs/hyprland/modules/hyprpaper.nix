{pkgs, ...}: let
  swww = lib.getExe pkgs.swww;
  swww-daemon = pkgs.swww + "/bin/swww-daemon";
in {
  wayland.windowManager.hyprland.settings = {
    exec-once = ["${swww} img ${wallpaper}"];
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
