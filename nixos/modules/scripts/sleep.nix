{ pkgs }:
pkgs.writeShellApplication {
  name = "sleep-screens";

  runtimeInputs = [
    pkgs.findutils
    pkgs.gawk
    pkgs.coreutils
    pkgs.curl
  ];

  text = ''
    HYPRLAND_INSTANCE_SIGNATURE=$(find /tmp/hypr -print0 -name '*.log' | xargs -0 stat -c '%Y %n' - | sort -rn | head -n 1 | cut -d ' ' -f2 | awk -F '/' '{print $4}')
    export HYPRLAND_INSTANCE_SIGNATURE
    curl -X 'PUT' 'http://link.bun-hexatonic.ts.net:8888/api/config' -H 'Content-Type:application/json' -d '{"global_brightness": 0.0}'
    hyprctl keyword monitor DP-3,disable
    hyprctl keyword monitor DP-1,disable
  '';
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
