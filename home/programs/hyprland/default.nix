{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  hyprpaper = pkgs.hyprpaper + "/bin/hyprpaper";
  swayosd-server = pkgs.swayosd + "/bin/swayosd-server";
  notifs = pkgs.mako + "/bin/mako";
  obsidian = pkgs.obsidian + "/bin/obsidian";
  blanket = pkgs.blanket + "/bin/blanket";
  plexamp = pkgs.plexamp + "/bin/plexamp";
  polkit = pkgs.polkit_gnome + "/libexec/polkit-gnome-authentication-agent-1";
  agent = pkgs.openssh + "/bin/ssh-agent";
  waybar = pkgs.waybar + "/bin/waybar";
  vlc = pkgs.vlc + "/bin/vlc";
  wallpaper = builtins.fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
    sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
  };
  sidewallpaper = builtins.fetchurl {
    url = "https://blusky.s3.us-west-2.amazonaws.com/SU_SKY.PNG";
    sha256 = "sha256:05jbbil1zk8pj09y52yhmn5b2np2fqnd4jwx49zw1h7pfyr7zsc8";
  };
in {
  imports = [
    ./conf/binds.nix
    ./conf/windowrules.nix
    ./conf/workspaces.nix
    ./modules/lockidle.nix
    ./modules/waybar.nix
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
  wayland.windowManager.hyprland.plugins = [
    inputs.Hyprspace.packages.${pkgs.system}.Hyprspace
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    env = XDG_SCREENSHOTS_DIR,/home/tunnel/Pictures/Screenshots
    env = QT_QPA_PLATFORM,wayland
    env = QT_QPA_PLATFORMTHEME,qt5ct
    env = XCURSOR_SIZE,32
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = MOZ_ENABLE_WAYLAND,1
    exec-once = foot --app-id=mpd ncmpcpp
    exec-once = ${polkit}
    exec-once = ${agent}
    exec-once = ${waybar}
    exec-once = ${hyprpaper}
    exec-once = ${notifs}
    exec-once = ${swayosd-server}
    exec-once = ${obsidian}
    exec-once = flatpak run app.bluebubbles.BlueBubbles
    exec-once = pypr
    bezier = wind, 0.05, 0.9, 0.1, 1.05
    bezier = winIn, 0.1, 1.1, 0.1, 1.1
    bezier = winOut, 0.3, -0.3, 0, 1
    bezier = liner, 1, 1, 1, 1
    bezier = linear, 0.0, 0.0, 1.0, 1.0

    animations {
        enabled = true
        # bezier = overshot, 0.05, 0.9, 0.1, 1.1
        bezier = overshot, 0.13, 0.99, 0.29, 1.1
        animation = windows, 1, 4, overshot, slide
        animation = border, 1, 10, default
        animation = fade, 1, 10, default
        animation = workspaces, 1, 6, overshot, slide
    }
  '';
  wayland.windowManager.hyprland.settings = {
    monitorSettings = lib.mkMerge [
      (lib.mkIf (osConfig.networking.hostName == "link") {monitor = ["DP-1,2560x1440@240,1200x0,1" "DP-3,1920x1200@60,0x0,1,transform,1"];})
      (lib.mkIf (osConfig.networking.hostName == "zelda") {monitor = [",highres,auto,2"];})
    ];
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
        contrast = 1.0;
        noise = 0.0117;
        passes = 3;
        size = 6;
        ignore_opacity = true;
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
      disable_autoreload = true;
      force_default_wallpaper = 0;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
      vfr = true;
    };
    input = {
      accel_profile = "flat";
      touchpad = {
        natural_scroll = true;
        disable_while_typing = false;
      };
    };
    xwayland = {
      force_zero_scaling = true;
    };
  };
  home.file = {
    ".config/hypr/hyprpaper.conf".text = ''
      preload = ${wallpaper}
      preload = ${sidewallpaper}
      wallpaper = eDP-1, ${wallpaper}
      wallpaper = DP-1,${wallpaper}
      wallpaper = DP-3,${sidewallpaper}
      splash = false
    '';
    ".config/hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = ["scratchpads"]
      [scratchpads.term]
      animation = "fromTop"
      command = "foot -a foot-dropterm"
      class = "foot-dropterm"
      size = "75% 60%"
      max_size = "2560px 100%"
      margin = 50

      [scratchpads.music]
      animation = "fromLeft"
      command = "foot -a foot-music ncmpcpp"
      class = "foot-music"
      size = "40% 90%"
      unfocus = "hide"
      lazy = true

      [scratchpads.volume]
      animation = "fromRight"
      command = "pavucontrol"
      class = "pavucontrol"
      size = "40% 90%"
      unfocus = "hide"
      lazy = true
    '';
  };
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    #theme = "Arc-Dark";
    extraConfig = {
      show-icons = true;
      icon-theme = "Papirus Dark";
      display-drun = "";
    };
  };
}
