{
  pkgs,
  lib,
  ...
}: {
  programs.mangohud = {
    enable = true;
    enableSessionWide = true;
    package = pkgs.callPackage ../../../pkgs/mangohud/default.nix {
      mangohud32 = pkgs.pkgsi686Linux.mangohud;
      inherit (pkgs.linuxPackages.nvidia_x11.settings) libXNVCtrl;
      inherit (pkgs.python3Packages) mako;
    };
    settings = {
      # fix some weird stylix defaults
      background_alpha = lib.mkForce 0.0; # Background in horizontal for some reason stretches the whole screen?
      font_size = lib.mkForce 16;
      font_size_text = lib.mkForce 16;
      no_small_font = true;
      font_scale = lib.mkForce 1.0;
      font_scale_media_player = 1.0;
      # custom stuff
      hud_no_margin = true;
      text_outline_thickness = 2;
      horizontal = true;
      time = true;
      vram = true;
      ram = true;

      time_no_label = true;
      time_format = "%H:%M";
      frame_timing = 0;
      fps_value = "90,144,240";
      media_player = true;
      media_player_format = "{artist} - {title}";
    };
  };
}
