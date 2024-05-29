{pkgs, ...}: let
  idle = pkgs.hypridle + "/bin/hypridle";
  lock = pkgs.hyprlock + "/bin/hyprlock";
  media-info = ''
    ${pkgs.playerctl}/bin/playerctl metadata --format "<span size=\"xx-large\" weight=\"bold\">{{ title }}</span><br/>{{ artist }} - {{ album }}"
  '';
in {
  home.file = {
    ".config/hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || ${lock}       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = ${lock}    # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
      }

      listener {
          timeout = 60                                # 2.5min.
          on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = brightnessctl -r                 # monitor backlight restor.
      }

      # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
      listener {
          timeout = 60                                          # 2.5min.
          on-timeout = brightnessctl -sd dell::kbd_backlight set 0% # turn off keyboard backlight.
          on-resume = brightnessctl -sd dell::kbd_backlight set 100%        # turn on keyboard backlight.
      }

      listener {
          timeout = 150                                 # 5min
          on-timeout = ${lock}            # lock screen when timeout has passed
      }

      # TODO Make zelda suspend and have the screen turn off, but don't have link do any of that.
      # listener {
      #     timeout = 300                                 # 5.5min
      #     on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
      #     on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
      # }
      # listener {
      #     timeout = 600                                # 30min
      #     on-timeout = systemctl suspend                # suspend pc
      # }
    '';
    # TODO Make all the widgets that display on DP-1 also display on eDP-1 for zelda. somehow.
    ".config/hypr/hyprlock.conf".text = ''
      $font = PragmataPro Liga
      general {
        hide_cursor = true
      }
      background {
        monitor =
        path = screenshot
        blur_passes = 3
        blur_size = 8
        noise = 0.0117
        contrast = 0.9
        brightness = 1.2
        vibrancy = 0.1696
        vibrancy_darkness = 0.0
      }
      # Display next three on DP-1 and eDP-1
      label {
        monitor = DP-1
        text = cmd[update:30000] echo "$(date +"%R")"
        color = rgb(245, 224, 220)
        font_size = 90
        font_family = $font
        shadow_passes = 4
        shadow_size = 4

        position = -30, 0
        halign = right
        valign = top
      }
      label {
        monitor = DP-1
        text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
        color = rgb(245, 224, 220)
        font_size = 25
        font_family = $font
        position = -30, -140
        halign = right
        valign = top
      }
      input-field {
          monitor = DP-1
          size = 200, 50
          outline_thickness = 3
          dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
          dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center = false
          dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
          outer_color = rgb(203, 166, 247)
          inner_color = rgb(49, 50, 68)
          font_color = rgb(245, 224, 220)
          fade_on_empty = true
          fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
          placeholder_text = <i>Password</i> # Text rendered in the input box when it's empty.
          hide_input = false
          rounding = -1 # -1 means complete rounding (circle/oval)
          check_color = rgb(204, 136, 34)
          fail_color = rgb(204, 34, 34) # if authentication failed, changes outer_color and fail message color
          fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
          fail_transition = 300 # transition time in ms between normal outer_color and fail_color
          capslock_color = -1
          numlock_color = -1
          bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
          invert_numlock = false # change color if numlock is off
          swap_font_color = false # see below

          position = 0, 50
          halign = center
          valign = bottom
      }
      # Album art & Media Info for Desktop
      label {
        monitor = DP-3
        text = cmd[update:0:true] ${media-info}
        color = rgb(245, 224, 220)
        font_size = 20
        font_family = $font
        position = 400, -26

        shadow_passes = 18
        shadow_size = 5
        halign = left
        valign = top
      }
      image {
        monitor = DP-3
        path = /home/tunnel/.local/share/mopidy/coverart.png
        size = 350
        rounding = 2
        reload_time = 0
        reload_cmd = mopidy-albumart
        position = 30, -20

        shadow_passes = 4
        shadow_size = 4
        halign = left
        valign = top
      }
      # TODO make this nicer. i'm repeating the whole module. split this into some nice nix code PLEASE
      # Album art & Media Info for Laptop
      label {
        monitor = eDP-1
        text = cmd[update:0:true] ${media-info}
        color = rgb(245, 224, 220)
        font_size = 20
        font_family = $font
        position = 400, 26

        shadow_passes = 18
        shadow_size = 5
        halign = left
        valign = bottom
      }
      image {
        monitor = eDP-1
        path = /home/tunnel/.local/share/mopidy/coverart.png
        size = 350
        rounding = 2
        reload_time = 0
        reload_cmd = mopidy-albumart
        position = 30, 20

        shadow_passes = 4
        shadow_size = 4
        halign = left
        valign = bottom
      }
    '';
  };
  wayland.windowManager.hyprland = {
    extraConfig = ''
      exec-once = ${idle}
    '';
    settings = {
      bind = [
        "SUPER, L, exec, ${lock}"
      ];
    };
  };
}
