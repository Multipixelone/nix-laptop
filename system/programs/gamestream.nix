{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  sh = lib.getExe pkgs.bash;
  hypr-dispatch = lib.getExe' config.programs.hyprland.package "hyprctl" + " dispatch exec [workspace 7]";
  steam = lib.getExe config.programs.steam.package + " --";
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {
    inherit (pkgs-stable) qt6;
    inherit (pkgs-stable) procps;
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
        mon_string="SUNSHINE,''${width}x''${height}@''${refresh_rate},0x1920,1"
        # Unlock PC (so I don't have to type password on Steam Deck)
        pkill -USR1 hyprlock || true
        systemctl --user stop hypridle
        hyprctl output create headless SUNSHINE
        hyprctl keyword monitor "$mon_string"
        hyprctl dispatch moveworkspacetomonitor 7 2
        hyprctl dispatch focusmonitor 2
        hyprctl dispatch workspace 7
      '';
    };
    undo-command = pkgs.writeShellApplication {
      name = "undo-command";
      runtimeInputs = packages;

      text = ''
        HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
        export HYPRLAND_INSTANCE_SIGNATURE
        systemctl --user start hypridle
        hyprctl dispatch moveworkspacetomonitor 7 1
        hyprctl workspace 7
        hyprctl output remove SUNSHINE
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
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
    # temporary until there's a new release that contains https://github.com/LizardByte/Sunshine/pull/3783
    package = pkgs.sunshine.overrideAttrs rec {
      version = "2025.509.184504";
      src = pkgs.fetchFromGitHub {
        owner = "LizardByte";
        repo = "Sunshine";
        tag = "v${version}";
        hash = "sha256-J7X/J7q7+O6Nn36xNvLr2wgAJT1pqAVO24X2etqcaDE=";
        fetchSubmodules = true;
      };
    };
    settings = {
      channels = 2;
      output_name = 2;
      capture = "wlr";
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
                pkgs.gamescope
                config.programs.steam.package
              ];
              text = ''
                gamescope \
                --backend wayland \
                --xwayland-count 2 \
                --display-index 2 \
                --fullscreen \
                --steam -- \
                steam -gamepadui -steamos3 -pipewire-dmabuf
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
