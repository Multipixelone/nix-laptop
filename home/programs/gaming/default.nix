{
  pkgs,
  inputs,
  config,
  ...
}: let
  wine = inputs.nix-gaming.packages.${pkgs.system}.wine-ge;
  mangohud = config.programs.mangohud.package;
in {
  imports = [
    ./mangohud.nix
    ./moondeck.nix
  ];
  home.packages = with pkgs; [
    gamescope
    discord
    lutris
    gamemode
    steamtinkerlaunch
    prismlauncher
    cemu
    # Custom wine game runners
    (callPackage ../../../pkgs/games/stray {
      inherit wine mangohud;
      location = "/media/TeraData/Games/stray";
    })
    (callPackage ../../../pkgs/games/cities-skylines-2 {
      inherit wine mangohud;
      location = "/media/TeraData/Games/cities-skylines-ii";
    })
  ];
}
