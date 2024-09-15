{...}: {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      # workspace rules
      "workspace 5 silent, title:^(Spotify( Premium)?)$"
      "workspace 5 silent, class:^(Plexamp)$"
      "workspace 5 silent, class:^(vlc)$"
      "workspace 5 silent, class:^(mpd)"
      "workspace 5 silent, class:^(com.rafaelmardojai.Blanket)$"
      "workspace 4 silent, class:^(obsidian)$"
      "workspace 6 silent, class:^(bluebubbles)$"
      "workspace 6 silent, class:^(discord)$"

      # center dialogs
      "center, title:^(Open File)(.*)$"
      "center, title:^(Select a File)(.*)$"
      "center, title:^(Choose wallpaper)(.*)$"
      "center, title:^(Open Folder)(.*)$"
      "center, title:^(Save As)(.*)$"
      "center, title:^(Library)(.*)$"
      "center, title:^(File Upload)(.*)$"

      # idle inhibit while watching videos
      "idleinhibit focus, class:^(mpv|.+exe|celluloid)$"
      "idleinhibit focus, class:^(firefox)$, title:^(.*YouTube.*)$"
      "idleinhibit always, title:^(Zoom Meeting)$"
      "idleinhibit fullscreen, class:^(firefox)$"
      # idle inhibit while pdf reader open
      "idleinhibit always, class:^(org.kde.okular)$"
      "idleinhibit always, class:^(org.pwmt.zathura)$"

      # float rules
      "float,class:^(Plexamp)$"
      "float,class:^(com.rafaelmardojai.Blanket)$"
      "float,class:^(vlc)$"
      "float,class:^(mpd)"
      "float,title:^(Spotify( Premium)?)$"
      "float,class:^(nm-applet)$"

      ## app specific rules
      # reaper dropdowns
      "move cursor,class:REAPER,floating:1"
      "noanim,class:REAPER"
      "nofocus,class:REAPER,title:^(menu)$"
      "nofocus,class:REAPER,title:^$"
      "idleinhibit always, class:REAPER"
      # firefox pin pip
      "float, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      # qalculate
      "float, class:^(qalculate-gtk)$"
      "pin, class:^(qalculate-gtk)$"
      "move 100%-40% 10%, class:^(qalculate-gtk)$"
      # pin ripdrag
      "pin, class:^(it.catboy.ripdrag)$"

      ## gaming rules
      # steam rules
      "workspace 7 silent,class:^(steam)$"
      "fullscreen, title:^(Steam Big Picture Mode)$" # fix keep steam big picture fullscreen
      "idleinhibit always, title:^(Steam Big Picture Mode)$"
      "idleinhibit focus, class:^(steam)$"
      "float,class:^(steam)$,title:^(Friends List)$"
      "size 500 1225,class:^(steam)$,title:^(Friends List)$"
      "float,class:^(steam)$,title:^(Steam Settings)$"

      # steam game rules
      "workspace 7 silent,class:^(steam_app_.*)$"
      "immediate, initialclass:^(steam_app_)(.*)$" # tear all games (not seeing any bugs)
      "immediate,class:^(cs2)$"
      "immediate,class:^(dota2)$"
      "idleinhibit always, class:^(steam_app_.*)$"

      # minecraft
      "workspace 7 silent,class:^(org.prismlauncher.*)$"
      "workspace 7 silent,class:^(Minecraft)$"

      # gw2
      "bordersize 0,title:^(Guild Wars 2)$"
      "opaque,title:^(Guild Wars 2)$"
      "noblur,title:^(Guild Wars 2)$"
      "noshadow,title:^(Guild Wars 2)$"
      "norounding,title:^(Guild Wars 2)$"
      # "stayfocused,title:^(Guild Wars 2)$"
      # "allowsinput,title:^(Guild Wars 2)$"

      # blish hud
      "noblur,title:^(Blish HUD)$"
      "float, title:^(Blish HUD)$"
      "center, title:^(Blish HUD)$"
      "nofocus, title:^(Blish HUD)$"
      "noinitialfocus, title:^(Blish HUD)$"
      "noborder, title:^(Blish HUD)$"
      "pin, title:^(Blish HUD)$"
      "opacity 0.10 0.10, title:^(Blish HUD)$"
    ];
    layerrule = [
      #"blur,waybar"
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
