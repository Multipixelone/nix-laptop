{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  mediaplayer = pkgs.callPackage ./mediaplayer.nix {};
in {
  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "PragmataPro Liga", "FiraCode Nerd Font";
        font-size: 13px;
      }

      window#waybar {
        background: transparent;
        background-color: rgba(255,0,0,0.0);
        color: #${config.lib.stylix.colors.base05};
        margin: 3px 3px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: transparent;
        margin-left: 0.5rem;
        border: none;
      }
      #workspaces button {
        box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
        background-color: #11111b ;
        border-radius: 15px;
        margin-right: 10px;
        padding: 10px;
        padding-top: 4px;
        padding-bottom: 2px;
        color: 	#89b4fa ;
        transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
      }
      #workspaces button.active{
        padding-right: 20px;
        box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
        padding-left: 20px;
        padding-bottom: 3px;
        background: rgb(203,166,247);
        background: radial-gradient(circle, rgba(203,166,247,1) 0%, rgba(193,168,247,1) 12%, rgba(249,226,175,1) 19%, rgba(189,169,247,1) 20%, rgba(182,171,247,1) 24%, rgba(198,255,194,1) 36%, rgba(177,172,247,1) 37%, rgba(170,173,248,1) 48%, rgba(255,255,255,1) 52%, rgba(166,174,248,1) 52%, rgba(160,175,248,1) 59%, rgba(148,226,213,1) 66%, rgba(155,176,248,1) 67%, rgba(152,177,248,1) 68%, rgba(205,214,244,1) 77%, rgba(148,178,249,1) 78%, rgba(144,179,250,1) 82%, rgba(180,190,254,1) 83%, rgba(141,179,250,1) 90%, rgba(137,180,250,1) 100%);
        background-size: 400% 400%;
        animation: gradient_f 20s ease-in-out infinite;
        transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button label{
        color: 	#89b4fa ;
        font-weight: bolder;
      }

      #workspaces button.active label{
        color: #11111b;
        font-weight: bolder;
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
        background-color: #${config.lib.stylix.colors.base02};
        padding: 0.7rem 0.5rem;
        margin: 5px 0;
      }
      #custom-playerlabel {
        border-radius: 0px 1rem 1rem 0px;
        background-color: #${config.lib.stylix.colors.base02};
        padding: 0px 0.5rem 0px 0px;
        margin-top: 5px;
        margin-bottom: 5px;
      }
      #image {
        border-radius: 1rem 0px 0px 1rem;
        background-color: #${config.lib.stylix.colors.base02};
        padding: 0px 0.5rem 0px 0.5rem;
        margin-top: 5px;
        margin-bottom: 5px;
      }
      #battery {
        color: #${config.lib.stylix.colors.base0B};
      }
      #pulseaudio {
        color: #${config.lib.stylix.colors.base09};
        border-radius: 0px 1rem 1rem 0px;
      }
      #clock {
        color: #${config.lib.stylix.colors.base0D};
        margin-left: 5px;
      }

      #battery.charging {
        color: #${config.lib.stylix.colors.base0B};
      }

      #battery.warning:not(.charging) {
        color: #${config.lib.stylix.colors.base08};
      }

      #backlight {
        color: #${config.lib.stylix.colors.base0A};
      }

      #backlight, #audio {
          border-radius: 0;
      }

      #network {
        color: #${config.lib.stylix.colors.base08};
        border-radius: 1rem 0px 0px 1rem;
        margin-left: 1rem;
      }

      #clock {
        color: #${config.lib.stylix.colors.base0E};
        border-radius: 1rem;
      }

      #custom-lock {
          border-radius: 1rem 0px 0px 1rem;
          color: #${config.lib.stylix.colors.base07};
      }

      #custom-power {
          margin-right: 1rem;
          border-radius: 0px 1rem 1rem 0px;
          color: @red;
      }

      #tray {
        margin-right: 0.5rem;
        border-radius: 1rem;
        margin: 5px;
        padding: 0.7rem 0.5rem;
      }
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: #eb4d4b;
      }

      @keyframes gradient {
        0% {
          background-position: 0% 50%;
        }
        50% {
          background-position: 100% 30%;
        }
        100% {
          background-position: 0% 50%;
        }
      }

      @keyframes gradient_f {
        0% {
          background-position: 0% 200%;
        }
          50% {
              background-position: 200% 0%;
          }
        100% {
          background-position: 400% 200%;
        }
      }

      @keyframes gradient_f_nh {
        0% {
          background-position: 0% 200%;
        }
        100% {
          background-position: 200% 200%;
        }
      }
    '';
    settings = [
      {
        height = 30;
        layer = "top";
        position = "top";
        output = lib.mkIf (osConfig.networking.hostName == "link") "DP-1";
        modules-left = ["hyprland/workspaces" "image#album-art" "custom/playerlabel"];
        modules-center = ["clock"];
        # TODO there has to be a less jank way to do this...
        # modules-right = lib.mkIf (osConfig.networking.hostName == "zelda") ["network" "pulseaudio" "backlight" "battery" "tray"];
        modules-right = ["network" "backlight" "battery" "pulseaudio" "clock" "tray"];
        "custom/playerlabel" = {
          format = ''<span>{}</span>'';
          return-type = "json";
          max-length = 80;
          exec = "${mediaplayer}/bin/mediaplayer.py";
        };
        "image#album-art" = {
          exec = "echo /home/tunnel/.local/share/mopidy/coverart.png";
          size = 30;
          interval = 30;
          # recieve signal from ncmpcpp to change song
          signal = 5;
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
            "6" = "󰭻";
          };
        };
        network = {
          format-wifi = "{icon} {essid}";
          format-ethernet = " Wired";
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
          format = "󰥔  {:%A, %b %d %R}";
        };
        battery = {
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
      }
    ];
  };
}
