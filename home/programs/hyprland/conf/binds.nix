{
  pkgs,
  inputs,
  lib,
  osConfig,
  ...
}: let
  terminal = lib.getExe pkgs.foot;
  brightness = lib.getExe pkgs.brillo;
  playerctl = lib.getExe pkgs.playerctl;
  swayosd-client = lib.getExe' pkgs.swayosd "swayosd-client";
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
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
      bind = let
        # this cool setup stolen from Aylur (https://github.com/Aylur/dotfiles/blob/7c4d6a708d426cb1a35a0f1776c4edc52ae1841c/home-manager/hyprland.nix)
        binding = mod: cmd: key: arg: "${mod}, ${key}, ${cmd}, ${arg}";
        mvfocus = binding "ALT" "movefocus";
        resizeactive = binding "Alt_Super" "resizeactive";
        mvwindow = binding "Alt_Shift" "movewindow";
        yt-mpv = pkgs.writeShellApplication {
          name = "yt";
          runtimeInputs = [pkgs.mpv pkgs.wl-clipboard pkgs.libnotify];
          text = ''
            URL=$(wl-paste)
            notify-send "Opening video" "$URL"
            mpv "$URL"
          '';
        };
      in
        [
          "ALT_SHIFT, Q, killactive"
          # app keybinds
          "$mod, RETURN, exec, ${terminal}"
          "ALT_SHIFT, W, exec, firefox"
          "ALT_SHIFT, D, exec, discord"
          "ALT_SHIFT, S, exec, steam"
          "ALT_SHIFT, C, exec, code"
          "ALT_SHIFT, Y, exec, ${lib.getExe yt-mpv}"
          # focus keybinds
          (mvfocus "h" "l")
          (mvfocus "j" "d")
          (mvfocus "k" "u")
          (mvfocus "l" "r")
          (mvwindow "h" "l")
          (mvwindow "j" "d")
          (mvwindow "k" "u")
          (mvwindow "l" "r")
          (resizeactive "h" "-80 0")
          (resizeactive "j" "0 80")
          (resizeactive "k" "0 -80")
          (resizeactive "l" "80 0")
          "$mod, p, pseudo"
          "$mod, s, togglesplit"
          # pypr scratchpads
          "Control_L&Alt_L, K, exec, pypr toggle password"
          "ALT_SHIFT, E, exec, pypr toggle music"
          "$mod, T, exec, pypr toggle term"
          "$mod, B, exec, pypr toggle volume"
          # screenshot & picker
          "$mod, C, exec, ${lib.getExe pkgs.hyprpicker} | ${wl-copy}"
          "$mod, X, exec, ${lib.getExe pkgs.cliphist} list | anyrun --show-results-immediately true --plugins ${inputs.anyrun.packages.${pkgs.system}.stdin}/lib/libstdin.so | ${lib.getExe pkgs.cliphist} decode | ${wl-copy}"
          ", Print, exec, ${lib.getExe pkgs.grimblast} --notify --cursor copysave output"
          "ALT , Print, exec, ${lib.getExe screenshot-area}"
          "$mod, SPACE, exec, anyrun"
          "$mod, ESCAPE, exit"
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
