{
  pkgs,
  inputs,
  ...
}: let
  hyprctl = pkgs.hyprland + "/bin/hyprctl";
  steam = pkgs.steam + "/bin/steam";
  sh = pkgs.bash + "/bin/bash";
  moondeck = pkgs.qt6.callPackage ../../pkgs/moondeck/default.nix {};
  appimagerun = pkgs.appimage-run + "/bin/appimage-run";
  gamemoderun = pkgs.gamemode + "/bin/gamemoderun";
  gamescope = pkgs.gamescope + "/bin/gamescope";
  streammon =
    pkgs.writeShellApplication {
      name = "streammon";
      runtimeInputs = [pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.curl pkgs.hyprland];

      text = ''
        #HYPRLAND_INSTANCE_SIGNATURE=$(find /tmp/hypr -print0 -name '*.log' | xargs -0 stat -c '%Y %n' - | sort -rn | head -n 1 | cut -d ' ' -f2 | awk -F '/' '{print $4}')
        #export HYPRLAND_INSTANCE_SIGNATURE
        width=''${1:-3840}
        height=''${2:-2160}
        refresh_rate=''${3:-60}
        mon_string="DP-1,''${width}x''${height}@''${refresh_rate},1200x0,1"
        hyprctl keyword monitor "DP-3,disable"
        hyprctl keyword monitor "$mon_string"
      '';
    }
    + "/bin/streammon";
  prep = [
    {
      do = "${sh} -c \"${streammon} \${SUNSHINE_CLIENT_WIDTH} \${SUNSHINE_CLIENT_HEIGHT}\"";
      undo = "${hyprctl} reload";
    }
  ];
in {
  services.sunshine = {
    enable = true;
    capSysAdmin = true;
    openFirewall = true;
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
          cmd = "${steam} -steamos -tenfoot -fulldesktopres";
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
    serviceConfig = {
      ExecStart = "${moondeck}/bin/MoonDeckBuddy";
    };
  };
}
#pkgs.writeShellApplication {
#name = "wake-screens";
#runtimeInputs = [ pkgs.findutils pkgs.gawk pkgs.coreutils pkgs.curl ];
#text = ''
#HYPRLAND_INSTANCE_SIGNATURE=$(find /tmp/hypr -print0 -name '*.log' | xargs -0 stat -c '%Y %n' - | sort -rn | head -n 1 | cut -d ' ' -f2 | awk -F '/' '{print $4}')
#export HYPRLAND_INSTANCE_SIGNATURE
#curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/scenes' -H 'Content-Type: application/json' -d '{"id": "main-purple", "action": "activate"}'
#curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/config' -H 'Content-Type:application/json' -d '{"global_brightness": 1.0}'
#hyprctl reload
#'';
#}
#}

