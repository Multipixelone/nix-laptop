{
  config,
  pkgs,
  nix-gaming,
  ...
}: let
  hyprpaper = pkgs.hyprpaper + "/bin/hyprpaper";
  swayosd-server = pkgs.swayosd + "/bin/swayosd-server";
  notifs = pkgs.mako + "/bin/mako";
  idle = pkgs.hypridle + "/bin/hypridle";
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
      rounding = "6";
      shadow_offset = "0 2";
      drop_shadow = true;
      shadow_ignore_window = true;
      shadow_range = 20;
      shadow_render_power = 3;
      "col.shadow" = pkgs.lib.mkForce "rgba(00000055)";
      blur = {
        enabled = true;
        brightness = 1.0;
        contrast = 1.0;
        noise = 0.02;
        passes = 3;
        size = 10;
      };
      #"col.shadow" = "rgba(00000099)";
    };
    general = {
      border_size = 3;
      gaps_in = 5;
      gaps_out = 5;
      "col.inactive_border" = pkgs.lib.mkForce "rgb(1e1e2e)";
      "col.active_border" = pkgs.lib.mkForce "rgb(cba6f7)";
    };
    dwindle = {
      # keep floating dimentions while tiling
      pseudotile = true;
      preserve_split = true;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_forever = true;
    };
    misc = {
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      vfr = true;
    };
    input = {
      accel_profile = "flat";
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
