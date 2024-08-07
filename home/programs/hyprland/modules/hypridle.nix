{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  timeout = 240;
  brillo = lib.getExe pkgs.brillo;
  pypr = lib.getExe pkgs.pyprland;
  suspendScript = pkgs.writeShellApplication {
    name = "suspend-script";
    runtimeInputs = [pkgs.playerctl pkgs.ripgrep pkgs.systemd];
    text = ''
      # only suspend if audio isn't running
      playerctl -a status | ripgrep running -q
      if [ $? == 1 ]; then
        systemctl suspend
      fi
    '';
  };
in {
  services.hypridle = {
    enable = true;
    package = inputs.hypridle.packages.${pkgs.system}.hypridle;
    settings = {
      general = {
        lock_cmd = lib.getExe config.programs.hyprlock.package;
        before_sleep_cmd = lib.getExe' pkgs.systemd "loginctl" + " lock-session";
      };
      listener = [
        {
          timeout = timeout - 20;
          on-timeout = "${brillo} -s dell::kbd_backlight -S 0";
          on-resume = "${brillo} -s dell::kbd_backlight -S 100";
        }
        {
          timeout = timeout - 10;
          on-timeout = "${brillo} -O; ${brillo} -u 1000000 -S 10";
          on-resume = "${brillo} -I -u 500000";
        }
        {
          inherit timeout;
          on-timeout = "loginctl lock-session";
        }
        # TODO do these on zelda, not link
        # {
        #   timeout = timeout + 120;
        #   on-timeout = "pypr toggle_dpms";
        #   on-resume = "pypr toggle_dpms";
        # }
        # {
        #   timeout = timeout + 60;
        #   on-timeout = suspendScript.outPath;
        # }
      ];
    };
  };
}
