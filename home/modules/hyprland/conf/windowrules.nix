{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # make Firefox PiP window floating and sticky
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"

      # throw sharing indicators away
      "workspace special silent, title:^(Firefox — Sharing Indicator)$"
      "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"

      # start Music & Obsidian in proper places
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
      "idleinhibit fullscreen, class:^(firefox)$"

      # Music Player & Blanket
      "float,class:^(Plexamp)$"
      "float,class:^(com.rafaelmardojai.Blanket)$"
      "float,class:^(vlc)$"
      "float,title:^(Spotify( Premium)?)$"
      "move 23 53,class:^(Plexamp)$"
      "size 1369 483,class:^(Plexamp)$"
      "move 1418 53,class:^(com.rafaelmardojai.Blanket)$"
      "size 479 1004,class:^(com.rafaelmardojai.Blanket)$"
      "move 23 562,class:^(vlc)$"
      "size 1369 495,class:^(vlc)$"
      "move 253 174,title:^(Spotify( Premium)?)$"
      "size 982 732,title:^(Spotify( Premium)?)$"

      # opacity rules
      "opacity 0.85 0.80,class:^(Spotify)$"
      "opacity 0.85 0.80,class:^(Plexamp)$"
      "opacity 0.85 0.80,class:^(vlc)$"
      "opacity 0.85 0.80,class:^(com.rafaelmardojai.Blanket)$"
      "opacity 0.85 0.80,class:^(pavucontrol)$"
      "opacity 0.85 0.80,class:^(nm-applet)$"
      "opacity 0.85 0.80,class:^(org.kde.polkit-kde-authentication-agent-1)$"
      # float rules
      "float,class:^(pavucontrol)$"
      "float,class:^(nm-applet)$"
    ];
    layerrule = [
      "blur,rofi"
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
