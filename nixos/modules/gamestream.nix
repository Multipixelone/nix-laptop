{pkgs, ...}: let
  steam = pkgs.steam + "/bin/steam -steamos3 -steampal -steamdeck -gamepadui";
  sh = pkgs.bash + "/bin/bash";
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {};
  hypr-dispatch = pkgs.hyprland + "/bin/hyprctl dispatch exec";
  streammon =
    pkgs.writeShellApplication {
      name = "streammon";
      runtimeInputs = [pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.curl pkgs.hyprland];

      text = ''
        width=''${1:-3840}
        height=''${2:-2160}
        refresh_rate=''${3:-60}
        mon_string="DP-1,''${width}x''${height}@''${refresh_rate},1200x0,1"
        curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "gaming-mode", "action": "activate"}'
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
        curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "main-purple", "action": "activate"}'
        hyprctl keyword monitor "DP-3,enable"
        hyprctl keyword monitor "$mon_string"
        pkill steam
      '';
    }
    + "/bin/undo-command";
  prep = [
    {
      do = "${sh} -c \"${streammon} \${SUNSHINE_CLIENT_WIDTH} \${SUNSHINE_CLIENT_HEIGHT} \${SUNSHINE_CLIENT_FPS}\"";
      undo = "${sh} -c \"${undo-command}\"";
    }
  ];
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
          prep-cmd = prep;
        }
        {
          name = "Steam Big Picture";
          cmd = "${hypr-dispatch} \"${steam}\"";
          prep-cmd = prep;
        }
        {
          name = "MoonDeckStream";
          cmd = "${moondeck}/bin/MoonDeckStream";
          prep-cmd = prep;
          auto-detatch = false;
        }
      ];
    };
  };
  systemd.user.services.moondeck = {
    description = "MoonDeck Buddy";
    wantedBy = ["graphical-session.target"];
    partOf = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];

    startLimitIntervalSec = 500;
    startLimitBurst = 5;

    serviceConfig = {
      ExecStart = "${moondeck}/bin/MoonDeckBuddy";
    };
  };
}
