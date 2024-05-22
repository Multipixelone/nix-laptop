{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    gamescope
    discord
    lutris
    gamemode
    steamtinkerlaunch
    prismlauncher
  ];
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    settings = {
      # fix some weird stylix defaults
      background_alpha = lib.mkForce 0.0;
      font_size = lib.mkForce 24;
      font_scale = lib.mkForce 1.0;
      # custom stuff
      text_outline_thickness = 2;
      # horizontal = true; # TODO write a mangohud patch to remove the forced newline before the music module
      wine = true;
      time = true;
      time_no_label = true;
      frame_timing = 0;
      fps_value = "90,144,240";
      media_player = true;
      media_player_format = "{artist} - {title}";
    };
  };
}
