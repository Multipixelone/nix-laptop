{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  sh = lib.getExe pkgs.bash;
  hypr-dispatch = lib.getExe' config.programs.hyprland.package "hyprctl" + " dispatch exec";
  steam = lib.getExe config.programs.steam.package + " --";
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {
    qt6 = pkgs-stable.qt6;
    procps = pkgs-stable.procps;
  };
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
        hyprctl keyword monitor "DP-3,disable"
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
        second_mon="DP-3,1920x1200@60,0x0,1,transform,1"
        systemctl --user start hypridle
        hyprctl keyword monitor "$second_mon"
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
  # imports = [
  #   inputs.jovian.nixosModules.default
  # ];
  environment.systemPackages = [
    inputs.jovian.legacyPackages.${pkgs.system}.gamescope-session
  ];
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      channels = 2;
      output_name = 0;
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
          name = "Steam (Gamescope)";
          cmd = let
            steam-gamescope = pkgs.writeShellApplication {
              name = "steam-gamescope";
              runtimeInputs = [
                inputs.jovian.legacyPackages.${pkgs.system}.gamescope
                config.programs.steam.package
              ];
              text = ''
                gamescope \
                -w 3840 \
                -h 2160 \
                --xwayland-count 2 \
                --backend wayland \
                -f \
                -e -- \
                steam -gamepadui
              '';
            };
          in "${hypr-dispatch} \"${lib.getExe steam-gamescope}\"";
          prep-cmd = [prep steam-kill];
          image-path = mk-icon {icon-name = "steamvr";};
        }
        {
          name = "Until Dawn";
          cmd = "${hypr-dispatch} \"until-dawn\"";
          prep-cmd = [prep];
          image-path = download-image {
            # Source: https://www.steamgriddb.com/grid/115256
            url = "https://cdn2.steamgriddb.com/grid/f28c89145bc5c930ba927088d63b196d.png";
            hash = "sha256-DPDqZlgVbo/Wig4AlXGqZoHxI9QGPrmhZzteWke6JMc=";
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
