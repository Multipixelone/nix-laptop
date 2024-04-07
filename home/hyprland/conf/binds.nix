{
  inputs,
  pkgs,
  ...
}: let
  terminal = pkgs.kitty + "/bin/kitty";
  rofi = pkgs.rofi-wayland + "/bin/rofi";
  launcher = "${rofi} -show drun";
  swayosd-client = pkgs.swayosd + "/bin/swayosd-client";
  brightness = pkgs.brightnessctl + "/bin/brightnessctl";
in {
  wayland.windowManager.hyprland.settings = {
    "$mod" = "ALT";
    bind = [
      "ALT_SHIFT, Q, killactive"
      "$mod, RETURN, exec, ${terminal}"
      "ALT_SHIFT, W, exec, firefox"
      "$mod, SPACE, exec, ${launcher}"
      "$mod, M, exit"
      "$mod, V, togglefloating"
      "SUPER, F, fullscreen"
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
