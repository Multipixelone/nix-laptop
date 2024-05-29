{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  # TODO move all of these into a "startup" definition
  swayosd-server = pkgs.swayosd + "/bin/swayosd-server";
  notifs = pkgs.mako + "/bin/mako";
  polkit = pkgs.polkit_gnome + "/libexec/polkit-gnome-authentication-agent-1";
  agent = pkgs.openssh + "/bin/ssh-agent";
  waybar = pkgs.waybar + "/bin/waybar";
  pypr = "${pkgs.pyprland}/bin/pypr";
  music-term = "${pkgs.foot}/bin/foot --app-id=mpd ncmpcpp";
  dbus = "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE";
in {
  imports = [
    ./conf/binds.nix
    ./conf/windowrules.nix
    ./conf/workspaces.nix
    ./modules/lockidle.nix
    ./modules/hyprpaper.nix
    ./modules/waybar.nix
    ./modules/anyrun.nix
    ./modules/gammastep.nix
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
  home.packages = with pkgs; [
    # TODO move this into a module so that it always comes with lockidle and waybar
    (writeShellApplication {
      name = "mopidy-albumart";
      runtimeInputs = [pkgs.playerctl pkgs.imagemagick];
      text = ''
        art_url=$(playerctl -p mopidy metadata mpris:artUrl)
        filename=''${art_url##*/}
        img_file="/home/tunnel/.local/share/mopidy/local/images/$filename"
        convert "$img_file" -resize 500x500^ -gravity Center -extent 500x500 /home/tunnel/.local/share/mopidy/coverart.png
        echo "/home/tunnel/.local/share/mopidy/coverart.png"
      '';
    })
  ];
  # TODO reorganize all of this and make it cleaner
  # TODO move all env def into session vars
  wayland.windowManager.hyprland = {
    enable = true;
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    extraConfig = ''
      env = XDG_SCREENSHOTS_DIR,/home/tunnel/Pictures/Screenshots
      env = QT_QPA_PLATFORM,wayland
      env = QT_QPA_PLATFORMTHEME,qt5ct
      env = XCURSOR_SIZE,32
      env = XDG_CURRENT_DESKTOP,Hyprland
      env = XDG_SESSION_TYPE,wayland
      env = XDG_SESSION_DESKTOP,Hyprland
      env = MOZ_ENABLE_WAYLAND,1
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
    settings = {
      # FIX Kinda jank mkMerge
      monitorSettings = lib.mkMerge [
        (lib.mkIf (osConfig.networking.hostName == "link") {monitor = ["DP-1,2560x1440@240,1200x0,1" "DP-3,1920x1200@60,0x0,1,transform,1"];})
        (lib.mkIf (osConfig.networking.hostName == "zelda") {monitor = [",highres,auto,2"];})
      ];
      exec-once = [polkit agent waybar notifs swayosd-server music-term pypr dbus];
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
          brightness = 1.1;
          noise = 0.0117;
          passes = 3;
          size = 16;
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
        workspace_swipe_cancel_ratio = 0.15;
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
  };
  home.file = {
    ".config/hypr/pyprland.toml".text = ''
      [pyprland]
      plugins = ["scratchpads", "toggle_dpms"]
      [scratchpads.term]
      animation = "fromTop"
      command = "foot -a foot-dropterm"
      class = "foot-dropterm"
      size = "75% 60%"
      max_size = "2560px 100%"
      margin = 50

      [scratchpads.music]
      animation = "fromLeft"
      command = "foot -a foot-music ncmpcpp -h link"
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

      [scratchpads.helvum]
      animation = "fromRight"
      command = "helvum"
      class = "org.pipewire.Helvum"
      size = "40% 90%"
      unfocus = "hide"
      lazy = true
    '';
  };
}
