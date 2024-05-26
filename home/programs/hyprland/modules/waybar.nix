{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  mediaplayer = pkgs.callPackage ./mediaplayer.nix {};
in {
  programs.waybar = {
    enable = true;
    style = ''
      ${builtins.readFile (builtins.fetchurl {
        url = "https://github.com/catppuccin/waybar/releases/download/v1.1/mocha.css";
        sha256 = "sha256:14anxdkg8s4rgd2xz7jar9b2vgidkwn1kk5pnn84i665wkvg6ncn";
      })}
      * {
        font-family: "PragmataPro Liga", "FiraCode Nerd Font";
        font-size: 13px;
        min-height: 0;
        box-shadow: none;
        background: transparent;
        background-color: rgba(255,0,0,0.0);
      }
      window#waybar {
        background: transparent;
        background-color: rgba(255,0,0,0.0);
        color: @text;
        margin: 3px 3px;
      }

      #workspaces {
        border-radius: 1rem;
        margin: 5px;
        background-color: @surface0;
        margin-left: 0.5rem;
        border: none;
      }

      #workspaces button {
        color: @lavender;
        border-radius: 0;
        padding: 0.4rem;
        border: none;
      }

      #workspaces button.active {
        color: @sky;
        border-radius: 0;
        border: none;
        box-shadow: none;
      }

      #workspaces button.focused {
        color: @sky;
        border-radius: 0;
        border: none;
        box-shadow: none;
      }

      #workspaces button:hover {
        color: @sapphire;
        border-radius: 0;
        border: none;
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
        padding: 0.7rem 0.5rem;
        margin: 5px 0;
      }
      #custom-playerlabel {
        border-radius: 0px 1rem 1rem 0px;
        background-color: @surface0;
        padding: 0px 0.5rem 0px 0px;
        margin-top: 5px;
        margin-bottom: 5px;
      }
      #image {
        border-radius: 1rem 0px 0px 1rem;
        background-color: @surface0;
        padding: 0px 0.5rem 0px 0.5rem;
        margin-top: 5px;
        margin-bottom: 5px;
      }
      #battery {
        color: @green;
        border-radius: 0px 1rem 1rem 0px;
      }
      #pulseaudio {
        color: @mauve
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
        margin-right: 0.5rem;
        border-radius: 1rem;
        margin: 5px;
        padding: 0.7rem 0.5rem;
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
        modules-right = lib.mkIf (osConfig.networking.hostName == "zelda") ["network" "pulseaudio" "backlight" "battery" "tray"];
        "custom/playerlabel" = {
          format = ''<span>{}</span>'';
          return-type = "json";
          max-length = 80;
          exec = "${mediaplayer}/bin/mediaplayer.py";
        };
        "image#album-art" = {
          exec = "mopidy-albumart";
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
          format = "{icon} {essid}";
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
