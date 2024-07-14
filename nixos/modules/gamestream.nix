{
  pkgs,
  lib,
  ...
}: let
  steam = "/run/current-system/sw/bin/steam --";
  sh = pkgs.bash + "/bin/bash";
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {};
  hypr-dispatch = pkgs.hyprland + "/bin/hyprctl dispatch exec";
  papirus = pkgs.papirus-icon-theme + /share/icons/Papirus-Dark/128x128/apps;
  wind-waker = "/media/BigData/Games/roms/wiiu/THE LEGEND OF ZELDA The Wind Waker HD [BCZE01]/code/cking.rpx";
  mkImage = {
    url,
    hash,
  }: let image = pkgs.fetchurl {inherit url hash;}; in pkgs.runCommand "${lib.nameFromURL url "."}.png" {} ''${pkgs.imagemagick}/bin/convert ${image} -background none -gravity center -extent 600x800 $out'';
  streammon =
    pkgs.writeShellApplication {
      name = "streammon";
      runtimeInputs = [pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.procps pkgs.curl pkgs.hyprland];

      text = ''
        width=''${1:-3840}
        height=''${2:-2160}
        refresh_rate=''${3:-60}
        mon_string="DP-1,''${width}x''${height}@''${refresh_rate},1200x0,1"
        # Unlock PC (so I don't have to type password on Steam Deck)
        pkill -USR1 hyprlock || true
        #curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "gaming-mode", "action": "activate"}'
        systemctl --user stop hypridle swww
        hyprctl keyword monitor "DP-3,disable"
        hyprctl keyword monitor "$mon_string"
      '';
    }
    + "/bin/streammon";
  undo-command =
    pkgs.writeShellApplication {
      name = "undo-command";
      runtimeInputs = [pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.curl pkgs.hyprland];

      text = ''
        mon_string="DP-1,2560x1440@240,1200x0,1"
        #curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "main-purple", "action": "activate"}'
        systemctl --user start hypridle swww
        hyprctl keyword monitor "DP-3,1920x1200@60,0x0,1,transform,1"
        hyprctl keyword monitor "$mon_string"
      '';
    }
    + "/bin/undo-command";
  prep = {
    do = "${sh} -c \"${streammon} \${SUNSHINE_CLIENT_WIDTH} \${SUNSHINE_CLIENT_HEIGHT} \${SUNSHINE_CLIENT_FPS}\"";
    undo = "${sh} -c \"${undo-command}\"";
  };
  # TODO I wrote this while high as fuck so i think i wrote it like actually so jank LMFAO absolutely ghoulish use of string concatenation
  steam-kill = {
    do = "";
    undo = "${sh} -c \"${pkgs.writeShellApplication {
        name = "steam-kill";
        runtimeInputs = [pkgs.procps];

        text = ''
          pkill steam
        '';
      }
      + "/bin/steam-kill"}\"";
  };
in {
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      channels = 3;
    };
    applications = {
      env = {
        PATH = "$(PATH)";
      };
      apps = [
        {
          name = "Desktop";
          prep-cmd = [prep];
          image-path = pkgs.runCommand "desktop.png" {} ''
            ${pkgs.imagemagick}/bin/convert -density 1200 -resize 500x -background none ${papirus}/cinnamon-virtual-keyboard.svg  -gravity center -extent 600x800 $out
          '';
        }
        {
          name = "Steam Big Picture";
          cmd = "${hypr-dispatch} \"${steam} -gamepadui\"";
          prep-cmd = [prep steam-kill];
          # TODO simplify this and stop repeating myself so much
          image-path = pkgs.runCommand "steambigpicture.png" {} ''
            ${pkgs.imagemagick}/bin/convert -density 1200 -resize 500x -background none ${papirus}/steamlink.svg  -gravity center -extent 600x800 $out
          '';
        }
        {
          name = "Steam (Regular UI)";
          cmd = "${hypr-dispatch} \"${steam}\"";
          prep-cmd = [prep steam-kill];
          image-path = pkgs.runCommand "steam.png" {} ''
            ${pkgs.imagemagick}/bin/convert -density 1200 -resize 500x -background none ${papirus}/steam.svg  -gravity center -extent 600x800 $out
          '';
        }
        {
          name = "Wind Waker HD";
          cmd = "${hypr-dispatch} \"${lib.getExe pkgs.cemu} -g \"${wind-waker}\"\"";
          prep-cmd = [prep];
          image-path = mkImage {
            url = "https://cdn2.steamgriddb.com/grid/8d5c0500d7ec1c04842c4b33673d0f43.png";
            hash = "sha256-jGDBJeCH7Ch5UGmYxEqypbWtg+qIT+DjEfE0HaVoDcU=";
          };
        }
        {
          name = "Stray";
          cmd = "${hypr-dispatch} \"stray\"";
          prep-cmd = [prep];
          image-path = mkImage {
            # Source: https://www.steamgriddb.com/grid/228086
            url = "https://cdn2.steamgriddb.com/grid/5792570eae5e9fd09de1927180ff513c.png";
            hash = "sha256-MeuQPkQp65azeFHE8FiYrahb34p3LYunqsL6ls95eWw=";
          };
        }
        {
          name = "Cities Skylines 2";
          cmd = "${hypr-dispatch} \"cities-skylines-ii\"";
          prep-cmd = [prep];
          image-path = mkImage {
            # Source: https://www.steamgriddb.com/grid/401805
            url = "https://cdn2.steamgriddb.com/grid/4b06c53a6d97eab539d8b8fc0be7a458.jpg";
            hash = "sha256-7z6+xKw4GvQv5IH2PTVq3TdKlp16u65pti4seN4ZEJs=";
          };
        }
        {
          name = "MoonDeckStream";
          cmd = "${moondeck}/bin/MoonDeckStream";
          prep-cmd = [prep];
          image-path = pkgs.runCommand "moondeck.png" {} ''
            ${pkgs.imagemagick}/bin/convert -density 1200 -resize 500x -background none ${papirus}/moonlight.svg  -gravity center -extent 600x800 $out
          '';
          auto-detatch = false;
        }
      ];
    };
  };
}
