{pkgs, ...}: {
  programs.ncmpcpp = {
    enable = true;
    settings = {
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "my_fifo";
      visualizer_in_stereo = "yes";
      visualizer_type = "ellipse";
      visualizer_look = "+|";
      playlist_display_mode = "columns";
      #execute_on_song_change = "bash ~/.config/ncmpcpp/mpd-notification";
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
      progressbar_color = "black";
      progressbar_elapsed_color = "white";
      progressbar_boldness = "yes";
      song_status_format = "$b$6%t$/b {$8by} $b$6%a$8$/b";
      song_list_format = "{$8%a ⠂ }{%t}$R{%l}";
      song_columns_list_format = "(50)[magenta]{ar} (50)[green]{t}";
      main_window_highlight_color = "green";
      main_window_color = "blue";
      color1 = "white";
      color2 = "red";
    };
  };
}
