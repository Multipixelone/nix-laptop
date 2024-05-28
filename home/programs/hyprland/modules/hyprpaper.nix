{
  lib,
  pkgs,
  ...
}: let
  # TODO move these to config.theme.wallpaper variables
  wallpaper = builtins.fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
    sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
  };
  sidewallpaper = builtins.fetchurl {
    url = "https://blusky.s3.us-west-2.amazonaws.com/SU_SKY.PNG";
    sha256 = "sha256:05jbbil1zk8pj09y52yhmn5b2np2fqnd4jwx49zw1h7pfyr7zsc8";
  };
in {
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ${wallpaper}
    preload = ${sidewallpaper}
    wallpaper = eDP-1, ${wallpaper}
    wallpaper = DP-1,${wallpaper}
    wallpaper = DP-3,${sidewallpaper}
    splash = false
  '';

  systemd.user.services.hyprpaper = {
    Unit = {
      Description = "Hyprland wallpaper daemon";
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${lib.getExe pkgs.hyprpaper}";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
