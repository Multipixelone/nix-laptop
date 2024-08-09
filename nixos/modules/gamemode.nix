# https://github.com/fufexan/dotfiles/blob/483680e121b73db8ed24173ac9adbcc718cbbc6e/system/programs/gamemode.nix
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  programs = [
    config.programs.hyprland.package
    pkgs.findutils
    pkgs.gawk
    pkgs.coreutils
    pkgs.curl
    pkgs.libnotify
    pkgs.mako
  ];
  startscript =
    pkgs.writeShellApplication {
      name = "gamemode-start";
      runtimeInputs = programs;
      text = ''
        SECRET=$(cat "${config.age.secrets."syncthing".path}")
        HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
        export HYPRLAND_INSTANCE_SIGNATURE
        # ledfx change scene (disabled temporarily)
        # curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "gaming-mode", "action": "activate"}'
        # send request to pause syncthing while game is playing
        curl -X POST -H "X-API-Key: $SECRET" http://localhost:8384/rest/system/pause
        hyprctl --batch 'keyword animations:enabled 0; keyword decoration:drop_shadow 0; keyword decoration:blur:enabled 0; keyword general:gaps_in 0; keyword general:gaps_out 0; keyword general:border_size 1; keyword decoration:rounding 0'
        notify-send -a 'Gamemode' 'Optimizations activated'
        makoctl mode -a dnd
      '';
    }
    + "/bin/gamemode-start";
  endscript =
    pkgs.writeShellApplication {
      name = "gamemode-end";
      runtimeInputs = programs;
      text = ''
        SECRET=$(cat "${config.age.secrets."syncthing".path}")
        HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
        export HYPRLAND_INSTANCE_SIGNATURE
        curl -X POST -H "X-API-Key: $SECRET" http://localhost:8384/rest/system/resume
        # curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "main-purple", "action": "activate"}'
        hyprctl --batch 'keyword animations:enabled 1; keyword decoration:drop_shadow 1; keyword decoration:blur:enabled 1; keyword general:gaps_in 5; keyword general:gaps_out 5; keyword general:border_size 3; keyword decoration:rounding 6'
        makoctl mode -r dnd
        notify-send -a 'Gamemode' 'Optimizations deactivated'
      '';
    }
    + "/bin/gamemode-end";
in {
  # Usage:
  #   1. For games/launchers which integrate GameMode support:
  #      https://github.com/FeralInteractive/GameMode#apps-with-gamemode-integration
  #      simply running the game will automatically activate GameMode.
  #   2. For others, launching the game through gamemoderun: `gamemoderun ./game`
  #   3. For steam: `gamemoderun steam-runtime`
  age.secrets = {
    "syncthing" = {
      file = "${inputs.secrets}/media/syncthing.age";
      mode = "400";
      owner = "tunnel";
      group = "users";
    };
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "auto";
        renice = 15;
        inhibit_screensaver = 0;
      };
      custom = {
        start = startscript;
        end = endscript;
      };
    };
  };
  security.wrappers.gamemode = {
    owner = "root";
    group = "root";
    source = "${lib.getExe' pkgs.gamemode "gamemoderun"}";
    capabilities = "cap_sys_ptrace,cap_sys_nice+pie";
  };
}
