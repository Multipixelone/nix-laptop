{
  pkgs,
  config,
  inputs,
  # lib,
  ...
}:
# TODO I really need to write this in a better way, but my laptop hates swww for some reason...
# wallpaper-set-link = pkgs.writeShellApplication {
#   name = "wallpaper-set";
#   runtimeInputs = [pkgs.swww];
#   text = ''
#     sleep 10
#     swww img -o DP-1 --transition-fps 240 --transition-type wave --transition-angle 60 --transition-step 30 ${config.theme.wallpaper}
#     swww img -o DP-3 --transition-fps 60 --transition-type wave --transition-angle 120 --transition-step 30 ${config.theme.side-wallpaper}
#   '';
# };
# wallpaper-set-zelda = let
#   morning = pkgs.fetchurl {
#     url = "https://github.com/zhichaoh/catppuccin-wallpapers/blob/main/landscapes/tropic_island_morning.jpg?raw=true";
#     hash = "sha256-v/NHtilkniGu+PXRegl24nMawu68b9HyzjykoXENb/M=";
#   };
#   day = pkgs.fetchurl {
#     url = "https://github.com/zhichaoh/catppuccin-wallpapers/blob/main/landscapes/tropic_island_day.jpg?raw=true";
#     hash = "sha256-Zm3G+c64Lr9jnG4CyhaNgE+W3VIQsODDxwDwvM+E2Qs=";
#   };
#   evening = pkgs.fetchurl {
#     url = "https://github.com/zhichaoh/catppuccin-wallpapers/blob/main/landscapes/tropic_island_evening.jpg?raw=true";
#     hash = "sha256-fa3xNinJ9H/W5wS9nHE00aqLhRPY3EslDYUryhvwZ7k=";
#   };
#   night = pkgs.fetchurl {
#     url = "https://github.com/zhichaoh/catppuccin-wallpapers/blob/main/landscapes/tropic_island_night.jpg?raw=true";
#     hash = "sha256-Fm800h7CbEHqcPDL7oKSBSIpGBhEWLFS6ioV5qM0SVw=";
#   };
# in
#   pkgs.writeShellApplication {
#     name = "wallpaper-set";
#     runtimeInputs = [pkgs.wbg];
#     text = ''
#       case $(date +%H) in
#       	03 | 04 | 05 | 06 | 07 | 08 | 09 | 10) # First 8 hours of the day
#           wbg ${morning}
#       		;;
#       	11 | 12 | 13 | 14 | 15) # Middle 8 hours of the day
#           wbg ${day}
#       		;;
#       	16 | 17 | 18 | 19)
#           wbg ${evening}
#           ;;
#         20 | 21 | 22 | 23 | 00 | 01 | 02 ) # Final 8 hours of the day
#           wbg ${night}
#       		;;
#       esac
#     '';
#   };
{
  # systemd.user.services.hyprpaper.Unit.After = lib.mkForce "graphical-session.target";
  services.hyprpaper = {
    enable = true;
    package = inputs.hyprpaper.packages.${pkgs.system}.default;
    settings = {
      ipc = "on";
      splash = false;
      preload = [
        config.theme.wallpaper
        config.theme.side-wallpaper
      ];
      wallpaper = [
        ",${config.theme.wallpaper}"
        "DP-3,${config.theme.side-wallpaper}"
      ];
    };
  };
}
