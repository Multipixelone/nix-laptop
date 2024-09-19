{
  pkgs,
  inputs,
  lib,
  config,
  osConfig,
  ...
}: let
  # TODO move all of these into a "startup" definition
  polkit = pkgs.polkit_gnome + "/libexec/polkit-gnome-authentication-agent-1";
  swayosd-server = lib.getExe' pkgs.swayosd "swayosd-server";
  waybar = lib.getExe pkgs.waybar;
  pypr = lib.getExe pkgs.pyprland;
  wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
  cliphist = lib.getExe pkgs.cliphist;
  hyprdim = lib.getExe pkgs.hyprdim + " -d 400 -f 35";
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
    ./modules/anyrun.nix
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
  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
    XDG_SESSION_TYPE = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = osConfig.programs.hyprland.package;
    plugins = [
      inputs.hyprspace.packages.${pkgs.system}.Hyprspace
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    ];
    systemd = {
      enable = true;
      variables = ["--all"];
    };
    extraConfig = ''
      # ripped from https://github.com/end-4/dots-hyprland/blob/b69f7cebe302dfcb2cdd1c83d87ab27f2c457c09/.config/hypr/hyprland/general.conf
      animations {
          enabled = true
          # Animation curves

          bezier = linear, 0, 0, 1, 1
          bezier = md3_standard, 0.2, 0, 0, 1
          bezier = md3_decel, 0.05, 0.7, 0.1, 1
          bezier = md3_accel, 0.3, 0, 0.8, 0.15
          bezier = overshot, 0.05, 0.9, 0.1, 1.1
          bezier = crazyshot, 0.1, 1.5, 0.76, 0.92
          bezier = hyprnostretch, 0.05, 0.9, 0.1, 1.0
          bezier = menu_decel, 0.1, 1, 0, 1
          bezier = menu_accel, 0.38, 0.04, 1, 0.07
          bezier = easeInOutCirc, 0.85, 0, 0.15, 1
          bezier = easeOutCirc, 0, 0.55, 0.45, 1
          bezier = easeOutExpo, 0.16, 1, 0.3, 1
          bezier = softAcDecel, 0.26, 0.26, 0.15, 1
          bezier = md2, 0.4, 0, 0.2, 1 # use with .2s duration
          # Animation configs
          animation = windows, 1, 3, md3_decel, popin 60%
          animation = windowsIn, 1, 3, md3_decel, popin 60%
          animation = windowsOut, 1, 3, md3_accel, popin 60%
          animation = border, 1, 10, default
          animation = fade, 1, 3, md3_decel
          # animation = layers, 1, 2, md3_decel, slide
          animation = layersIn, 1, 3, menu_decel, slide
          animation = layersOut, 1, 1.6, menu_accel
          animation = fadeLayersIn, 1, 2, menu_decel
          animation = fadeLayersOut, 1, 4.5, menu_accel
          animation = workspaces, 1, 7, menu_decel, slide
          # animation = workspaces, 1, 2.5, softAcDecel, slide
          # animation = workspaces, 1, 7, menu_decel, slidefade 15%
          # animation = specialWorkspace, 1, 3, md3_decel, slidefadevert 15%
          animation = specialWorkspace, 1, 3, md3_decel, slidevert
      }
    '';
    settings = {
      # FIX Kinda jank mkMerge
      monitorSettings = lib.mkMerge [
        (lib.mkIf (osConfig.networking.hostName == "link") {monitor = ["DP-1,2560x1440@240,1200x0,1" "DP-3,1920x1200@60,0x0,1,transform,1"];})
        (lib.mkIf (osConfig.networking.hostName == "zelda") {monitor = [",highres,auto,2"];})
      ];
      exec-once = [polkit waybar swayosd-server pypr watch-clipboard watch-images hyprdim];
      debug.disable_logs = false;
      env = [
        "XDG_SCREENSHOTS_DIR,/home/tunnel/Pictures/Screenshots"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "XCURSOR_SIZE,32"
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_DESKTOP,Hyprland"
        "MOZ_ENABLE_WAYLAND,1"
        "HYPRCURSOR_THEME,Posy_Cursor_Black_h"
        "HYPRCURSOR_SIZE,24"
      ];
      decoration = {
        rounding = "10";
        shadow_offset = "1 3";
        # only enable drop shadow on link
        drop_shadow = lib.mkIf (osConfig.networking.hostName == "link") true;
        shadow_ignore_window = true;
        shadow_range = 30;
        shadow_render_power = 4;
        active_opacity = 1;
        inactive_opacity = 1;
        "col.shadow" = lib.mkForce "rgba(01010166)";
        "col.shadow_inactive" = lib.mkForce "0x22000000";
        # enable blur on desktop (costly)
        blur = lib.mkIf (osConfig.networking.hostName == "link") {
          enabled = true;
          xray = true;
          brightness = 1.1;
          noise = 0.02;
          contrast = 1;
          passes = 4;
          size = 7;
          ignore_opacity = true;
          popups = true;
          popups_ignorealpha = 0.6;
        };
        #"col.shadow" = "rgba(00000099)";
      };
      general = {
        allow_tearing = true;
        border_size = 0;
        gaps_in = 4;
        gaps_out = 6;
        gaps_workspaces = 20;
        resize_on_border = true;
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
        workspace_swipe_create_new = true;
      };
      misc = {
        disable_autoreload = true;
        background_color = "rgb(${config.lib.stylix.colors.base00})";
        force_default_wallpaper = 0;
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        animate_manual_resizes = true;
        new_window_takes_over_fullscreen = 2;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };
      render = {
        direct_scanout = true;
        explicit_sync = true;
      };
      cursor = {
        inactive_timeout = "7";
        persistent_warps = true;
      };
      input = {
        accel_profile = "flat";
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.5;
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
      lazy = true

      [scratchpads.music]
      animation = "fromLeft"
      command = "foot -a foot-music ncmpcpp"
      class = "foot-music"
      size = "40% 90%"
      unfocus = "hide"
      lazy = false

      [scratchpads.gpt]
      animation = "fromLeft"
      command = "foot -a foot-gpt tgpt -m"
      class = "foot-gpt"
      size = "40% 90%"
      unfocus = "hide"
      lazy = true

      [scratchpads.volume]
      animation = "fromRight"
      command = "${lib.getExe pkgs.pwvucontrol}"
      class = "com.saivert.pwvucontrol"
      size = "40% 90%"
      unfocus = "hide"
      lazy = true

      [scratchpads.bluetooth]
      animation = "fromRight"
      command = "${lib.getExe' pkgs.blueman "blueman-manager"}"
      class = ".blueman-manager-wrapped"
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
      lazy = false
    '';
  };
}
