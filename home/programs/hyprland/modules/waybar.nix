{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}: let
  # dynamic pill totally stolen from https://github.com/flick0/dotfiles/blob/702facf3bc3bce37991efdba6efb68c7477ea770/config/hypr/scripts/tools/start_dyn
  dynamic = pkgs.stdenv.mkDerivation {
    name = "dynamic";
    propagatedBuildInputs = [
      pkgs.python3
      pkgs.waybar-mpris
    ];
    dontUnpack = true;
    installPhase = "install -Dm755 ${pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/flick0/dotfiles/aurora/config/hypr/scripts/tools/dynamic";
      hash = "sha256-MgDKAmHEgjOH+A7HAdhxBzShYNqxS78+7+EVhYvwsLI=";
    }} $out/bin/dynamic";
  };
  start-dyn =
    pkgs.writeShellApplication {
      name = "start-dyn";
      runtimeInputs = [dynamic pkgs.jq];

      text = ''
        #!/usr/bin/bash
        dynamic &
        while true
        do
          out=$(cat ~/.config/hypr/store/dynamic_out.txt)
          echo "$out"  | jq --unbuffered --compact-output
          sleep 1
        done
      '';
    }
    + "/bin/start-dyn";
in {
  home.packages = with pkgs; [waybar-mpris];
  wayland.windowManager.hyprland.settings.exec-once = [(dynamic + "/bin/dynamic &")];
  programs.waybar = {
    enable = true;
    style = ''
      * {
        font-family: "PragmataPro Liga", "FiraCode Nerd Font";
        font-size: 13px;
      }

      #custom-music,
      #tray,
      #backlight,
      #clock,
      #battery,
      #pulseaudio,
      #custom-lock,
      #custom-power,
      #custom-dynamic,
      #network {
        background-color: #${config.lib.stylix.colors.base02};
        padding: 0 10px;
        margin-top: 5px;
        margin-right: 10px;
        border-radius: 20px;
        color: #${config.lib.stylix.colors.base05};
        box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
      }

      window#waybar {
        background: transparent;
        color: #${config.lib.stylix.colors.base05};
      }

      #workspaces {
        margin-right: 10px;
        margin-left: 10px;
        margin-top: 5px;
        background-color: transparent;
      }
      #workspaces button {
        box-shadow: rgba(0, 0, 0, 0.116) 2 2 5 2px;
        background-color: #${config.lib.stylix.colors.base02};
        border-radius: 30px;
        margin-right: 10px;
        padding: 10px;
        padding-top: 4px;
        padding-bottom: 2px;
        color: 	#${config.lib.stylix.colors.base0E};
        transition: all 0.5s cubic-bezier(.55,-0.68,.48,1.68);
      }
      #workspaces button.active{
        padding-right: 20px;
        box-shadow: rgba(0, 0, 0, 0.288) 2 2 5 2px;
        border-radius: 30px;
        padding-left: 20px;
        padding-bottom: 3px;
        background: rgb(203,166,247);
        background: radial-gradient(circle, rgba(203,166,247,1) 0%, rgba(193,168,247,1) 12%, rgba(249,226,175,1) 19%, rgba(189,169,247,1) 20%, rgba(182,171,247,1) 24%, rgba(198,255,194,1) 36%, rgba(177,172,247,1) 37%, rgba(170,173,248,1) 48%, rgba(255,255,255,1) 52%, rgba(166,174,248,1) 52%, rgba(160,175,248,1) 59%, rgba(148,226,213,1) 66%, rgba(155,176,248,1) 67%, rgba(152,177,248,1) 68%, rgba(205,214,244,1) 77%, rgba(148,178,249,1) 78%, rgba(144,179,250,1) 82%, rgba(180,190,254,1) 83%, rgba(141,179,250,1) 90%, rgba(137,180,250,1) 100%);
        background-size: 400% 400%;
        transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
      }

      #workspaces button label{
        color: 	#${config.lib.stylix.colors.base0E};
        font-weight: bolder;
      }

      #workspaces button.active label{
        color: #${config.lib.stylix.colors.base02};
        font-weight: bolder;
      }

      #custom-dynamic label {
        color: #${config.lib.stylix.colors.base02};
        font-weight: bold;
      }

      #custom-dynamic.paused label {
        color: #${config.lib.stylix.colors.base0E};
        font-weight: bolder;
      }

      #custom-dynamic.low{
        background: rgb(148,226,213);
        background: linear-gradient(52deg, rgba(148,226,213,1) 0%, rgba(137,220,235,1) 19%, rgba(116,199,236,1) 43%, rgba(137,180,250,1) 56%, rgba(180,190,254,1) 80%, rgba(186,187,241,1) 100%);
        background-size: 300% 300%;
        text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
        font-weight: bolder;
        color: #fff;
      }
      #custom-dynamic.normal{
        background: rgb(148,226,213);
        background: radial-gradient(circle, rgba(148,226,213,1) 0%, rgba(156,227,191,1) 21%, rgba(249,226,175,1) 34%, rgba(158,227,186,1) 35%, rgba(163,227,169,1) 59%, rgba(148,226,213,1) 74%, rgba(164,227,167,1) 74%, rgba(166,227,161,1) 100%);
        background-size: 400% 400%;
        text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
        font-weight: bolder;
        color: #fff;
      }
      #custom-dynamic.critical{
        background: rgb(235,160,172);
        background: linear-gradient(52deg, rgba(235,160,172,1) 0%, rgba(243,139,168,1) 30%, rgba(231,130,132,1) 48%, rgba(250,179,135,1) 77%, rgba(249,226,175,1) 100%);
        background-size: 300% 300%;
        text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
        font-weight: bolder;
        color: #fff;
      }

      #custom-dynamic.playing{
        background: rgb(137,180,250);
        background: radial-gradient(circle, rgba(137,180,250,120) 0%, rgba(142,179,250,120) 6%, rgba(148,226,213,1) 14%, rgba(147,178,250,1) 14%, rgba(155,176,249,1) 18%, rgba(245,194,231,1) 28%, rgba(158,175,249,1) 28%, rgba(181,170,248,1) 58%, rgba(205,214,244,1) 69%, rgba(186,169,248,1) 69%, rgba(195,167,247,1) 72%, rgba(137,220,235,1) 73%, rgba(198,167,247,1) 78%, rgba(203,166,247,1) 100%);
        background-size: 400% 400%;
        text-shadow: 0 0 5px rgba(0, 0, 0, 0.377);
        font-weight: bold;
        color: #${config.lib.stylix.colors.base01};
      }

      #custom-dynamic.paused{
        background: #${config.lib.stylix.colors.base02};
        font-weight: bolder;
        color: #${config.lib.stylix.colors.base0E};
      }
      #custom-playerlabel {
        border-radius: 0px 1rem 1rem 0px;
        background-color: #${config.lib.stylix.colors.base02};
        padding: 0px 0.5rem 0px 0px;
        margin-bottom: 5px;
      }
      #image {
        border-radius: 1rem 0px 0px 1rem;
        background-color: #${config.lib.stylix.colors.base02};
        padding: 0px 0.5rem 0px 0.5rem;
        margin-bottom: 5px;
      }
      #battery {
        color: #${config.lib.stylix.colors.base0B};
      }
      #pulseaudio {
        color: #${config.lib.stylix.colors.base09};
      }
      #clock {
        color: #${config.lib.stylix.colors.base0D};
      }

      #battery.warning {
        color: #${config.lib.stylix.colors.base0A};
      }
      #battery.critical:not(.charging) {
        color: #${config.lib.stylix.colors.base08};
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }
      #battery.charging, #battery.plugged {
        color: #${config.lib.stylix.colors.base0B};
      }
      @keyframes blink {
        to {
            color: #${config.lib.stylix.colors.base06};
        }
      }

      #backlight {
        color: #${config.lib.stylix.colors.base0C};
      }

      #network {
        color: #${config.lib.stylix.colors.base08};
      }

      #clock {
        color: #${config.lib.stylix.colors.base0E};
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
        modules-left = ["hyprland/workspaces"]; #"image#album-art" "custom/playerlabel"];
        modules-center = ["custom/dynamic"];
        modules-right = [
          "backlight"
          "pulseaudio"
          "battery"
          "network"
          "clock"
          "tray"
        ];
        "custom/playerlabel" = {
          format = ''<span>{}</span>'';
          return-type = "json";
          max-length = 80;
          # exec = "${mediaplayer}/bin/mediaplayer.py";
        };
        "custom/dynamic" = {
          return-type = "json";
          format = "{}";
          exec = start-dyn;
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
          format-disconnected = "󰤭 Disconnected";
        };
        pulseaudio = {
          format = "{icon} {volume}";
          format-muted = "󰝟";
          format-icons = {
            "alsa_output.usb-Focusrite_Scarlett_8i6_USB_F8337319501296-00.pro-output-0" = "󰋋";
            "alsa_output.pci-0000_0e_00.4.analog-stereo" = "󰜟";
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
          states = {
            warning = 30;
            critical = 20;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}% {time}";
          format-time = "{H}:{M} to full";
          format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        };
      }
    ];
  };
}
