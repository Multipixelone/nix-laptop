{
  config,
  pkgs,
  nix-gaming,
  ...
}: let
  terminal = pkgs.kitty + "/bin/kitty";
  rofi = pkgs.rofi-wayland + "/bin/rofi";
  launcher = "${rofi} -show drun";
  hyprpaper = pkgs.hyprpaper + "/bin/hyprpaper";
  swayosd-server = pkgs.swayosd + "/bin/swayosd-server";
  swayosd-client = pkgs.swayosd + "/bin/swayosd-client";
  notifs = pkgs.mako + "/bin/mako";
  idle = pkgs.hypridle + "/bin/hypridle";
  lock = pkgs.hyprlock + "/bin/hyprlock";
  wallpaper = builtins.fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
    sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
  };
in {
  imports = [
    ./binds.nix
  ];
  services.mako = {
    enable = true;
    borderColor = pkgs.lib.mkForce "#cba6f7";
    backgroundColor = pkgs.lib.mkForce "#1e1e2e";
    borderRadius = 6;
    borderSize = 2;
    ignoreTimeout = true;
    defaultTimeout = 5000;
  };
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.extraConfig = ''
    monitor=,highres,auto,2
    env = GDK_SCALE,2
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_QPA_PLATFORM,"wayland;xcb"
    env = XCURSOR_SIZE,32
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = MOZ_ENABLE_WAYLAND,1
    exec-once = ${hyprpaper}
    exec-once = ${notifs}
    exec-once = ${idle}
    exec-once = ${swayosd-server}
  '';
  wayland.windowManager.hyprland.settings = {
    decoration = {
      shadow_offset = "0 5";
      rounding = "6";
      blur = {
        enabled = true;
      };
      #"col.shadow" = "rgba(00000099)";
    };
    general = {
      border_size = 2;
      gaps_in = 5;
      gaps_out = 5;
      "col.inactive_border" = pkgs.lib.mkForce "rgb(1e1e2e)";
      "col.active_border" = pkgs.lib.mkForce "rgb(cba6f7)";
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      vfr = true;
    };
    input = {
      touchpad = {
        natural_scroll = true;
      };
    };
    xwayland = {
      force_zero_scaling = true;
    };
  };
  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      wallpaper = eDP-1, ${wallpaper}
    '';
  };
}
