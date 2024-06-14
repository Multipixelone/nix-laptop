{pkgs, ...}: let
  steam = "/run/current-system/sw/bin/steam --";
  sh = pkgs.bash + "/bin/bash";
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {};
  hypr-dispatch = pkgs.hyprland + "/bin/hyprctl dispatch exec";
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
        }
        {
          name = "Steam Big Picture";
          cmd = "${hypr-dispatch} \"${steam} -gamepadui\"";
          prep-cmd = [prep steam-kill];
        }
        {
          name = "Steam (Regular UI)";
          cmd = "${hypr-dispatch} \"${steam}\"";
          prep-cmd = [prep steam-kill];
        }
        # {
        #   name = "Firefox";
        #   cmd = "${hypr-dispatch} \"firefox\"";
        #   prep-cmd = [prep];
        # }
        # {
        #   name = "Terminal";
        #   cmd = "${hypr-dispatch} \"foot\"";
        #   prep-cmd = [prep];
        # }
        {
          name = "MoonDeckStream";
          cmd = "${moondeck}/bin/MoonDeckStream";
          prep-cmd = [prep];
          auto-detatch = false;
        }
      ];
    };
  };
}
