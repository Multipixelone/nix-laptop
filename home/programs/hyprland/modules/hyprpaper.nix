{pkgs, ...}: let
  swww-daemon = pkgs.swww + "/bin/swww-daemon";
in {
  # xdg.configFile."hypr/hyprpaper.conf".text = ''
  #   preload = ${config.theme.wallpaper}
  #   preload = ${config.theme.side-wallpaper}
  #   wallpaper = eDP-1, ${config.theme.wallpaper}
  #   wallpaper = DP-1,${config.theme.wallpaper}
  #   wallpaper = DP-3,${config.theme.side-wallpaper}
  #   splash = false
  # '';
  #
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
