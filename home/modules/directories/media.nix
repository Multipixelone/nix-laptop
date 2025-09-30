{ lib, ... }:
{
  options.directories = {
    music-directory = lib.mkOption {
      description = ''
        Location where music is stored on the computer
      '';
      type = lib.types.path;
      example = lib.literalExample "./wallpaper.png";
    };
  };
}
