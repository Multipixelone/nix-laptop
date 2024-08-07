{
  pkgs,
  lib,
  ...
}: let
  terminal = pkgs.foot + "/bin/foot";
  launcher = "${pkgs.rofi-wayland}/bin/rofi -show drun";
  swayosd-client = pkgs.swayosd + "/bin/swayosd-client";
  brightness = lib.getExe pkgs.brillo;
  playerctl = pkgs.playerctl + "/bin/playerctl";
  screenshot = pkgs.grimblast + "/bin/grimblast";
  screenshotarea = ''hyprctl keyword animation "fadeOut,0,0,default"; ${screenshot} --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"'';
in {
  wayland.windowManager.hyprland = {
    extraConfig = ''
      bind=ALT_SHIFT, P, submap, passthrough
      submap=passthrough
      bind=, escape, submap, reset
      submap=reset
    '';
    settings = {
      "$mod" = "ALT";
      bind = [
        "ALT_SHIFT, Q, killactive"
        "$mod, RETURN, exec, ${terminal}"
        "ALT_SHIFT, W, exec, firefox"
        "ALT_SHIFT, D, exec, discord"
        "ALT_SHIFT, S, exec, steam"
        "ALT_SHIFT, C, exec, code"
        "ALT_SHIFT, E, exec, pypr toggle music"
        ", Print, exec, ${screenshot} --notify --cursor copysave output"
        "ALT , Print, exec, ${screenshotarea}"
        "$mod, SPACE, exec, ${launcher}"
        "$mod, M, exit"
        "$mod, N, exec, systemctl suspend"
        "$mod, V, togglefloating"
        "SUPER, F, fullscreen"
        "ALT, Tab, workspace, previous"
        "$mod, T, exec, pypr toggle term"
        "$mod, B, exec, pypr toggle volume"
        "$mod, H, exec, pypr toggle helvum"
        "Control_L&Alt_L, K, exec, pypr toggle password"
        #", swipe:3:ld, exec, pypr toggle music"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod SHIFT, 1, movetoworkspacesilent, 1"
        "$mod SHIFT, 2, movetoworkspacesilent, 2"
        "$mod SHIFT, 3, movetoworkspacesilent, 3"
        "$mod SHIFT, 4, movetoworkspacesilent, 4"
        "$mod SHIFT, 5, movetoworkspacesilent, 5"
        "$mod SHIFT, 6, movetoworkspacesilent, 6"
        "$mod SHIFT, 7, movetoworkspacesilent, 7"
        "$mod SHIFT, 8, movetoworkspacesilent, 8"
        "$mod SHIFT, 9, movetoworkspacesilent, 9"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindl = [
        ", XF86AudioPlay, exec, ${playerctl} play-pause"
        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioPrev, exec, ${playerctl} previous"
      ];
      bindel = [
        ", XF86AudioRaiseVolume, exec, ${swayosd-client} --output-volume raise"
        ", XF86AudioLowerVolume, exec, ${swayosd-client} --output-volume lower"
        ", XF86AudioMute, exec, ${swayosd-client} --output-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, ${brightness} -A 5"
        ", XF86MonBrightnessDown, exec, ${brightness} -U 5"
      ];
    };
  };
}
