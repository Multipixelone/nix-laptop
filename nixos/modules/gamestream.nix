{
  pkgs,
  lib,
  config,
  ...
}: let
  sh = lib.getExe pkgs.bash;
  hypr-dispatch = lib.getExe' config.programs.hyprland.package "hyprctl" + " dispatch exec";
  steam = lib.getExe config.programs.steam.package + " --";
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {};
  # icon download and crop functions
  mk-icon = {icon-name}: pkgs.runCommand "${icon-name}-scaled.png" {} ''${pkgs.imagemagick}/bin/convert -density 1200 -resize 500x -background none ${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/128x128/apps/${icon-name}.svg -gravity center -extent 600x800 $out'';
  download-image = {
    url,
    hash,
  }: let
    image = pkgs.fetchurl {inherit url hash;};
  in
    pkgs.runCommand "${lib.nameFromURL url "."}.png" {} ''${pkgs.imagemagick}/bin/convert ${image} -background none -gravity center -extent 600x800 $out'';
  # monitor prep command
  prep = let
    packages = [
      pkgs.findutils
      pkgs.gawk
      pkgs.coreutils
      pkgs.procps
      pkgs.curl
      config.programs.hyprland.package
    ];
    do-command = pkgs.writeShellApplication {
      name = "do-command";
      runtimeInputs = packages;

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
        hyprctl dispatch workspace 7
      '';
    };
    undo-command = pkgs.writeShellApplication {
      name = "undo-command";
      runtimeInputs = packages;

      text = ''
        HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
        export HYPRLAND_INSTANCE_SIGNATURE
        mon_string="DP-1,2560x1440@240,1200x0,1"
        systemctl --user start hypridle
        hyprctl dispatch dpms on DP-3
        hyprctl keyword monitor "$mon_string"
      '';
    };
  in {
    do = "${sh} -c \"${lib.getExe do-command} \${SUNSHINE_CLIENT_WIDTH} \${SUNSHINE_CLIENT_HEIGHT} \${SUNSHINE_CLIENT_FPS}\"";
    undo = "${sh} -c \"${lib.getExe undo-command}\"";
  };
  steam-kill = let
    kill-script = pkgs.writeShellApplication {
      name = "steam-kill";
      runtimeInputs = [pkgs.procps];
      text = ''
        pkill steam
      '';
    };
  in {
    do = "";
    undo = "${sh} -c \"${lib.getExe kill-script}\"";
  };
in {
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      channels = 2;
      output_name = 1;
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
          image-path = mk-icon {icon-name = "cinnamon-virtual-keyboard";};
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
          image-path = mk-icon {icon-name = "steamlink";};
        }
        {
          name = "Steam (Regular UI)";
          cmd = "${hypr-dispatch} \"${steam}\"";
          prep-cmd = [prep steam-kill];
          image-path = mk-icon {icon-name = "steam";};
        }
        {
          name = "Cities Skylines 2";
          cmd = "${hypr-dispatch} \"cities-skylines-ii\"";
          prep-cmd = [prep];
          image-path = download-image {
            # Source: https://www.steamgriddb.com/grid/401805
            url = "https://cdn2.steamgriddb.com/grid/4b06c53a6d97eab539d8b8fc0be7a458.jpg";
            hash = "sha256-7z6+xKw4GvQv5IH2PTVq3TdKlp16u65pti4seN4ZEJs=";
          };
        }
        {
          name = "MoonDeckStream";
          cmd = "${moondeck}/bin/MoonDeckStream";
          prep-cmd = [prep];
          image-path = mk-icon {icon-name = "moonlight";};
          auto-detatch = false;
        }
      ];
    };
  };
}
