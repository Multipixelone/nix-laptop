{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  # TODO move all of these into a "startup" definition
  swayosd-server = pkgs.swayosd + "/bin/swayosd-server";
  polkit = pkgs.polkit_gnome + "/libexec/polkit-gnome-authentication-agent-1";
  waybar = lib.getExe pkgs.waybar;
  pypr = lib.getExe pkgs.pyprland;
  term = lib.getExe pkgs.foot;
  music-term = "${term} --app-id=mpd ncmpcpp";
  foot-server = "${term} --server";
  wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
  cliphist = lib.getExe pkgs.cliphist;
  watch-clipboard = "${wl-paste} --type text --watch ${cliphist} store";
  watch-images = "${wl-paste} --type image --watch ${cliphist} store";
  cursor-theme = pkgs.fetchzip {
    url = "https://blusky.s3.us-west-2.amazonaws.com/Posy_Cursor_Black_h.tar.gz";
    hash = "sha256-EC4bKLo1MAXOABcXb9FneoXlV2Fkb9wOFojewaSejZk=";
  };
in {
  imports = [
    ./conf/binds.nix
    ./conf/windowrules.nix
    ./conf/workspaces.nix
    ./modules/hyprlock.nix
    ./modules/hypridle.nix
    ./modules/hyprpaper.nix
    ./modules/waybar.nix
    ./modules/rofi.nix
    ./modules/gammastep.nix
  ];
  services = {
    ssh-agent.enable = true;
    mako = {
      enable = true;
      borderColor = lib.mkForce "#${config.lib.stylix.colors.base0E}";
      backgroundColor = lib.mkForce "#${config.lib.stylix.colors.base00}";
      borderRadius = 6;
      borderSize = 2;
      ignoreTimeout = true;
      defaultTimeout = 5000;
    };
  };
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
      env = HYPRCURSOR_THEME,Posy_Cursor_Black_h
      env = HYPRCURSOR_SIZE,24
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
      exec-once = [polkit waybar swayosd-server music-term pypr foot-server watch-clipboard watch-images];
      decoration = {
        rounding = "6";
        shadow_offset = "0 2";
        drop_shadow = true;
        shadow_ignore_window = true;
        shadow_range = 20;
        shadow_render_power = 3;
        active_opacity = 1;
        inactive_opacity = 0.85;
        "col.shadow" = lib.mkForce "rgba(00000055)";
        "col.shadow_inactive" = lib.mkForce "0x22000000";
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
        allow_tearing = true;
        border_size = 3;
        gaps_in = 7;
        gaps_out = 10;
        "col.inactive_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base00})";
        "col.active_border" = lib.mkForce "rgb(${config.lib.stylix.colors.base0E})";
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
        background_color = "rgb(${config.lib.stylix.colors.base00})";
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = false;
        animate_manual_resizes = true;
        no_direct_scanout = false;
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
      binds = {
        allow_workspace_cycles = true;
      };
    };
  };
  home.file = {
    ".local/share/icons/Posy_Cursor_Black_h".source = cursor-theme;
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

      [scratchpads.password]
      animation = "fromBottom"
      command = "1password"
      class = "1Password"
      size = "40% 30%"
      max_size = "2560px 100%"
      position = "1% 66%"
      lazy = true
    '';
  };
}
