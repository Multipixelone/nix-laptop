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
  obsidian = pkgs.obsidian + "/bin/obsidian";
  blanket = pkgs.blanket + "/bin/blanket";
  plexamp = pkgs.plexamp + "/bin/plexamp";
  polkit = pkgs.polkit_gnome + "/libexec/polkit-gnome-authentication-agent-1";
  agent = pkgs.openssh + "/bin/ssh-agent";
  waybar = pkgs.waybar + "/bin/waybar";
  vlc = pkgs.vlc + "/bin/vlc";
  mediaplayer = pkgs.callPackage ./mediaplayer.nix {};
  wallpaper = builtins.fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
    sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
  };
in {
  imports = [
    ./binds.nix
    ./windowrules.nix
    ./workspaces.nix
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
    env = QT_SCALE_FACTOR,2
    env = QT_QPA_PLATFORM,"wayland;xcb"
    env = XCURSOR_SIZE,32
    env = XDG_CURRENT_DESKTOP,Hyprland
    env = XDG_SESSION_TYPE,wayland
    env = XDG_SESSION_DESKTOP,Hyprland
    env = MOZ_ENABLE_WAYLAND,1
    exec-once = ${polkit}
    exec-once = ${agent}
    exec-once = ${waybar}
    exec-once = ${hyprpaper}
    exec-once = ${notifs}
    exec-once = ${idle}
    exec-once = ${swayosd-server}
    exec-once = ${obsidian}
    exec-once = ${blanket}
    exec-once = ${plexamp}
    exec-once = ${vlc} --start-paused /home/tunnel/Music/Playlists/02\ vgm\ st.m3u8
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
    ".config/hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }

      listener {
          timeout = 150                                # 2.5min.
          on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = brightnessctl -r                 # monitor backlight restor.
      }

      # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
      listener {
          timeout = 150                                          # 2.5min.
          on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
          on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
      }

      listener {
          timeout = 300                                 # 5min
          on-timeout = loginctl lock-session            # lock screen when timeout has passed
      }

      listener {
          timeout = 330                                 # 5.5min
          on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
          on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
      }

      listener {
          timeout = 1800                                # 30min
          on-timeout = systemctl suspend                # suspend pc
      }
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
  programs.waybar = {
    enable = true;
    style = ''
      ${builtins.readFile (builtins.fetchurl {
        url = "https://github.com/catppuccin/waybar/releases/download/v1.1/mocha.css";
        sha256 = "sha256:14anxdkg8s4rgd2xz7jar9b2vgidkwn1kk5pnn84i665wkvg6ncn";
      })}
      * {
        font-family: "PragmataPro Liga", "FiraCode Nerd Font";
      }
      window#waybar {
        background: transparent;
        color: @text;
        margin: 5px 5px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 1rem;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 1rem;
        padding: 0.4rem;
      }

      #workspaces button.active {
        color: @sky;
        border-radius: 1rem;
      }

      #workspaces button:hover {
        color: @sapphire;
        border-radius: 1rem;
      }

      #custom-music,
      #tray,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #custom-power,
      #network {
        background-color: @surface0;
        padding: 0.5rem 1rem;
        margin: 5px 0;
      }
      #custom-playerlabel {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        padding: 0.5rem;
      }
      #battery {
        color: @green;
        border-radius: 0px 1rem 1rem 0px;
      }

      #clock {
        color: @blue;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
      }

      #backlight {
        color: @yellow;
      }

      #backlight, #audio {
          border-radius: 0;
      }

      #network {
        color: @maroon;
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #clock {
        color: @mauve;
        border-radius: 1rem;
      }

      #custom-lock {
          border-radius: 1rem 0px 0px 1rem;
          color: @lavender;
      }

      #custom-power {
          margin-right: 1rem;
          border-radius: 0px 1rem 1rem 0px;
          color: @red;
      }

      #tray {
        margin-right: 1rem;
        border-radius: 1rem;
      }
    '';
    settings = [
      {
        height = 30;
        layer = "top";
        position = "top";
        modules-left = ["hyprland/workspaces" "custom/playerlabel"];
        modules-center = ["clock"];
        #modules-right = ["network" "pulseaudio" "battery" "tray"];
        modules-right = ["network" "pulseaudio" "backlight" "battery" "tray"];
        "custom/playerlabel" = {
          format = ''<span>{}</span>'';
          return-type = "json";
          max-length = 80;
          exec = "${mediaplayer}/bin/mediaplayer.py";
        };
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "󰎤";
            "2" = "󰎧";
            "3" = "󰎪";
            "4" = "󰎚";
            "5" = "󰝚";
          };
        };
        network = {
          format = "{icon} {essid} ({signalStrength}%)";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          format-disconnected = "󰤭";
        };
        pulseaudio = {
          format = "{icon} {volume}";
          format-muted = "󰝟";
          format-icons = {
            headphones = "󰋋";
            default = ["󰕿" "󰖀" "󰕾"];
          };
          on-click = "pavucontrol";
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["󰃚" "󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠"];
        };
        clock = {
          format = "{%A, %d %b %Y} at {%l:%M %p}";
        };
        battery = {
          format = "{icon} {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
      }
    ];
  };
}
