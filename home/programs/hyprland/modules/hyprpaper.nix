{pkgs, ...}: let
  swww = lib.getExe pkgs.swww;
  swww-daemon = pkgs.swww + "/bin/swww-daemon";
  wallpaper = builtins.fetchurl {
    url = "https://blusky.s3.us-west-2.amazonaws.com/castle.GIF";
    sha256 = "sha256:0wbgyqp5wn4j65k5qcn5c1p5f1ppyg4yhjwqncyv6d9xxv2s72sy";
  };
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
