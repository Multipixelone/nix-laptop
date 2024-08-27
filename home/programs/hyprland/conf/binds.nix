{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  terminal = lib.getExe pkgs.foot;
  brightness = lib.getExe pkgs.brillo;
  playerctl = lib.getExe pkgs.playerctl;
  launcher = lib.getExe pkgs.rofi-wayland + " -show drun";
  swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";
  screenshot-area = pkgs.writeShellApplication {
    name = "screenshot-area";
    runtimeInputs = [osConfig.programs.hyprland.package pkgs.grimblast];
    text = ''
      hyprctl keyword animation "fadeOut,0,0,default"
      grimblast --notify copysave area
      hyprctl keyword animation "fadeOut,1,4,default"'';
  };
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
      bind =
        [
          "ALT_SHIFT, Q, killactive"
          # app keybinds
          "$mod, RETURN, exec, ${terminal}"
          "ALT_SHIFT, W, exec, firefox"
          "ALT_SHIFT, D, exec, discord"
          "ALT_SHIFT, S, exec, steam"
          "ALT_SHIFT, C, exec, code"
          # pypr scratchpads
          "Control_L&Alt_L, K, exec, pypr toggle password"
          "ALT_SHIFT, E, exec, pypr toggle music"
          "$mod, T, exec, pypr toggle term"
          "$mod, B, exec, pypr toggle volume"
          ", Print, exec, ${lib.getExe pkgs.grimblast} --notify --cursor copysave output"
          "ALT , Print, exec, ${lib.getExe screenshot-area}"
          "$mod, SPACE, exec, ${launcher}"
          "$mod, M, exit"
          "$mod, N, exec, systemctl suspend"
          "$mod, V, togglefloating"
          "SUPER, F, fullscreen"
          "ALT, Tab, workspace, previous"
          # "$mod, H, exec, pypr toggle helvum"
          #", swipe:3:ld, exec, pypr toggle music"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            )
            10)
        );
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
