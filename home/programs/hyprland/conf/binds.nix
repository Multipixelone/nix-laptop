{
  pkgs,
  ...
}: let
  terminal = pkgs.foot + "/bin/foot";
  launcher = "anyrun";
  swayosd-client = pkgs.swayosd + "/bin/swayosd-client";
  brightness = pkgs.brightnessctl + "/bin/brightnessctl";
  playerctl = pkgs.playerctl + "/bin/playerctl";
  screenshot = pkgs.grimblast + "/bin/grimblast";
  screenshotarea = ''hyprctl keyword animation "fadeOut,0,0,default"; ${screenshot} --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"'';
in {
  wayland.windowManager.hyprland.settings = {
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
      "$mod, T, exec, pypr toggle term"
      "$mod, B, exec, pypr toggle volume"
      ", XF86AudioPlay, exec, ${playerctl} play-pause"
      ", XF86AudioNext, exec, ${playerctl} next"
      ", XF86AudioPrev, exec, ${playerctl} previous"
      "$mod, 1, workspace, 1"
      "$mod, 2, workspace, 2"
      "$mod, 3, workspace, 3"
      "$mod, 4, workspace, 4"
      "$mod, 5, workspace, 5"
      "$mod, 6, workspace, 6"
      "$mod, 7, workspace, 7"
      "$mod, 8, workspace, 8"
      "$mod, 9, workspace, 9"
      "$mod SHIFT, 1, movetoworkspace, 1"
      "$mod SHIFT, 2, movetoworkspace, 2"
      "$mod SHIFT, 3, movetoworkspace, 3"
      "$mod SHIFT, 4, movetoworkspace, 4"
      "$mod SHIFT, 5, movetoworkspace, 5"
      "$mod SHIFT, 6, movetoworkspace, 6"
      "$mod SHIFT, 7, movetoworkspace, 7"
      "$mod SHIFT, 8, movetoworkspace, 8"
      "$mod SHIFT, 9, movetoworkspace, 9"
    ];
    bindm = [
      # mouse movements
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      #"$mod ALT, mouse:272, resizewindow"
    ];
    binde = [
      ", XF86AudioRaiseVolume, exec, ${swayosd-client} --output-volume raise"
      ", XF86AudioLowerVolume, exec, ${swayosd-client} --output-volume lower"
      ", XF86AudioMute, exec, ${swayosd-client} --output-volume mute-toggle"
      ", XF86MonBrightnessUp, exec, ${brightness} s +5%"
      ", XF86MonBrightnessDown, exec, ${brightness} s 5%-"
    ];
  };
}
