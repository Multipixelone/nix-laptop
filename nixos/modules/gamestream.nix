{
  pkgs,
  lib,
  config,
  ...
}: let
  sh = lib.getExe pkgs.bash;
  hypr-dispatch = lib.getExe' config.programs.hyprland.package "hyprctl" + "dispatch exec";
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {};
  papirus = pkgs.papirus-icon-theme + /share/icons/Papirus-Dark/128x128/apps;
  steam = lib.getExe config.programs.steam.package + "/bin/steam --";
  mkImage = {
    url,
    hash,
  }: let image = pkgs.fetchurl {inherit url hash;}; in pkgs.runCommand "${lib.nameFromURL url "."}.png" {} ''${pkgs.imagemagick}/bin/convert ${image} -background none -gravity center -extent 600x800 $out'';
  streammon =
    pkgs.writeShellApplication {
      name = "streammon";
      runtimeInputs = [pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.procps pkgs.curl config.programs.hyprland.package];

      text = ''
        HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
        export HYPRLAND_INSTANCE_SIGNATURE
        width=''${1:-3840}
        height=''${2:-2160}
        refresh_rate=''${3:-60}
        mon_string="DP-1,''${width}x''${height}@''${refresh_rate},1200x0,2"
        # Unlock PC (so I don't have to type password on Steam Deck)
        pkill -USR1 hyprlock || true
        systemctl --user stop hypridle
        hyprctl dispatch dpms off DP-3
        hyprctl keyword monitor "$mon_string"
      '';
    }
    + "/bin/streammon";
  undo-command =
    pkgs.writeShellApplication {
      name = "undo-command";
      runtimeInputs = [pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.curl config.programs.hyprland.package];

      text = ''
        HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
        export HYPRLAND_INSTANCE_SIGNATURE
        mon_string="DP-1,2560x1440@240,1200x0,1"
        systemctl --user start hypridle
        hyprctl dispatch dpms on DP-3
        hyprctl keyword monitor "$mon_string"
      '';
    }
    + "/bin/undo-command";
  prep = {
    do = "${sh} -c \"${streammon} \${SUNSHINE_CLIENT_WIDTH} \${SUNSHINE_CLIENT_HEIGHT} \${SUNSHINE_CLIENT_FPS}\"";
    undo = "${sh} -c \"${undo-command}\"";
  };
  # TODO I wrote this while high as fuck so i wrote it like actually so jank LMFAO absolutely ghoulish use of string concatenation
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
      channels = 1;
      # encoder = "amdvce";
      # decrease fec percentage because I am not dropping many packets
      fec_percentage = "7";
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
          name = "Prism Launcher";
          prep-cmd = [prep];
          cmd = "${hypr-dispatch} \"prismlauncher\"";
          image-path = pkgs.runCommand "prismlauncher.png" {} ''
            ${pkgs.imagemagick}/bin/convert -density 1200 -resize 500x -background none ${pkgs.prismlauncher}/share/icons/hicolor/scalable/apps/org.prismlauncher.PrismLauncher.svg -gravity center -extent 600x800 $out
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
