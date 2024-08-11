{...}: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # float & pin firefox pip
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # workspace rules
      "workspace 5 silent, title:^(Spotify( Premium)?)$"
      "workspace 5 silent, class:^(Plexamp)$"
      "workspace 5 silent, class:^(vlc)$"
      "workspace 5 silent, class:^(mpd)"
      "workspace 5 silent, class:^(com.rafaelmardojai.Blanket)$"
      "workspace 4 silent, class:^(obsidian)$"
      "workspace 6 silent, class:^(bluebubbles)$"
      "workspace 6 silent, class:^(discord)$"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit always, title:^(Zoom Meeting)$"
      "idleinhibit always, title:^(Steam Big Picture Mode)$"
      "idleinhibit fullscreen, class:^(firefox)$"

      # Steam Big Picture stay fullscreen
      "fullscreen, title:^(Steam Big Picture Mode)$"

      # music player default location
      "move 62 1428, class:^(mpd)"
      "size 754 422, class:^(mpd)"

      # opacity rules
      "opacity 0.85 0.80,class:^(Spotify)$"
      "opacity 0.85 0.80,class:^(Plexamp)$"
      "opacity 0.85 0.80,class:^(vlc)$"
      "opacity 0.85 0.80,class:^(com.rafaelmardojai.Blanket)$"
      "opacity 0.85 0.80,class:^(pavucontrol)$"
      "opacity 0.85 0.80,class:^(nm-applet)$"
      "opacity 0.85 0.80,class:^(org.kde.polkit-kde-authentication-agent-1)$"
      "opacity 0.85 0.80,class:^(anyrun)$"

      # float rules
      "float,class:^(Plexamp)$"
      "float,class:^(com.rafaelmardojai.Blanket)$"
      "float,class:^(vlc)$"
      "float,class:^(mpd)"
      "float,title:^(Spotify( Premium)?)$"
      "float,class:^(pavucontrol)$"
      "float,class:^(nm-applet)$"
      "float,title:^(Friends List)$"
      "float,title:^(Steam Settings)$"

      # gw2
      "immediate,title:^(Guild Wars 2)$"
      "bordersize 0,title:^(Guild Wars 2)$"
      "opaque,title:^(Guild Wars 2)$"
      "noblur,title:^(Guild Wars 2)$"
      "noshadow,title:^(Guild Wars 2)$"
      "norounding,title:^(Guild Wars 2)$"
      "stayfocused,title:^(Guild Wars 2)$"
      "allowsinput,title:^(Guild Wars 2)$"
      "workspace 9 silent, title:$(Guild Wars 2)$"

      # blish hud
      "float, title:^(Blish HUD)$"
      "center, title:^(Blish HUD)$"
      "nofocus, title:^(Blish HUD)$"
      "noinitialfocus, title:^(Blish HUD)$"
      "noborder, title:^(Blish HUD)$"
      "pin, title:^(Blish HUD)$"
      "opacity 0.2 0.1, title:^(Blish HUD)$"
      "workspace 9 silent, title:$(Blish HUD)$"

      # tearing rules
      "immediate,class:^(cs2)$"
      "immediate,class:^(dota2)$"
      # mh:w
      "immediate,class:^(steam_app_582010)$"
      # overwatch 2
      "immediate,class:^(steam_app_2357570)$"
    ];
    layerrule = [
      #"blur,waybar"
      "ignorezero,rofi"
      "blur,notifications"
      "ignorezero,notifications"
      "blur,swaync-notification-window"
      "ignorezero,swaync-notification-window"
      "blur,swaync-control-center"
      "ignorezero,swaync-control-center"
      "blur,logout_dialog"
    ];
  };
}
