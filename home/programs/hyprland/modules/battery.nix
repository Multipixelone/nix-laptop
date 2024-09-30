{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  script = pkgs.writeShellApplication {
    name = "watch-battery";
    runtimeInputs = with pkgs; [
      coreutils
      findutils
      inotify-tools
      osConfig.programs.hyprland.package
    ];
    text = ''
      BAT=$(echo /sys/class/power_supply/BAT*)
      BAT_STATUS="$BAT/status"
      BAT_CAP="$BAT/capacity"
      HYPRLAND_INSTANCE_SIGNATURE=$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)
      export HYPRLAND_INSTANCE_SIGNATURE

      # start the monitor loop
      currentStatus=$(cat "$BAT_STATUS")
      prevStatus=Charging

      # initial run
      if [ "$currentStatus" = "Discharging" ]; then
        hyprctl keyword decoration:blur:enabled false
      else
        hyprctl keyword decoration:blur:enabled true
      fi

      prevStatus="$currentStatus"

      # event loop
      while true; do
        currentStatus=$(cat "$BAT_STATUS")
        if [ "$currentStatus" != "$prevStatus" ]; then
        	# read the current state
        	if [ "$currentStatus" = "Discharging" ]; then
            hyprctl keyword decoration:blur:enabled false
        	else
            hyprctl keyword decoration:blur:enabled true
        	fi
          prevStatus="$currentStatus"
        fi

      	# wait for the next power change event
      	inotifywait -qq "$BAT_STATUS" "$BAT_CAP"
      done
    '';
  };
in {
  systemd.user.services.power-monitor = {
    Unit = {
      Description = "Hypr Power Monitor";
      After = ["greetd.service"];
    };

    Service = {
      Type = "simple";
      ExecStart = lib.getExe script;
      Restart = "on-failure";
    };

    Install.WantedBy = ["default.target"];
  };
}
