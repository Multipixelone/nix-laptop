{pkgs, ...}: let
  song-change =
    pkgs.writeShellApplication {
      name = "song-change";
      runtimeInputs = [pkgs.procps pkgs.libnotify pkgs.playerctl pkgs.imagemagick pkgs.mpc-cli];
      text = ''
        # i don't need to be making a playerctl and a mpc call, but then I have to write code to parse the output and I am Lazy
        art_url=$(playerctl -p mopidy metadata mpris:artUrl)
        filename=''${art_url##*/}
        img_file="/home/tunnel/.local/share/mopidy/local/images/$filename"

        magick convert "$img_file" -resize 500x500^ -gravity Center -extent 500x500 /home/tunnel/.local/share/mopidy/coverart.png

        # send album art to notification
        notify-send -r 27072 "$(mpc --format '%title% \n%artist% - %album%' current)" -i /home/tunnel/.local/share/mopidy/coverart.png

        # update waybar
        pkill -RTMIN+5 waybar
        # update hyprlock
        pkill -USR2 hyprlock
      '';
    }
    + "/bin/song-change &> /dev/null";
in {
  programs.ncmpcpp = {
    enable = true;
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "ellipse";
      visualizer_look = "+|";
      playlist_display_mode = "columns";
      execute_on_song_change = song-change;
      message_delay_time = 1;
      autocenter_mode = "yes";
      centered_cursor = "yes";
      ignore_leading_the = "yes";
      allow_for_physical_item_deletion = "no";
      song_window_title_format = "mpd » {%a - }{%t}|{%f}";
      statusbar_visibility = "yes";
      header_visibility = "no";
      titles_visibility = "no";
      progressbar_look = "━━━";
      progressbar_color = "black:b";
      progressbar_elapsed_color = "white:b";
      song_status_format = "$b$6%t$/b {$8by} $b$6%a$8$/b";
      song_list_format = "{$8%a ⠂ }{%t}$R{%l}";
      song_columns_list_format = "(50)[magenta]{ar} (50)[green]{t}";
      main_window_color = "blue";
      color1 = "white";
      color2 = "red";
    };
  };
}
