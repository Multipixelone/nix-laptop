{
  pkgs,
  inputs,
  config,
  ...
}: let
  umu = inputs.umu.packages.${pkgs.system}.umu;
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
    # Custom umu game runners
    (callPackage ../../../pkgs/games/cities-skylines-2 {
      inherit umu mangohud;
      location = "/media/TeraData/Games/cities-skylines-ii";
    })
    (callPackage ../../../pkgs/games/silent-hill-2 {
      inherit umu mangohud;
      location = "/media/BigData/Games/silent-hill-2-directors-cut";
    })
    (callPackage ../../../pkgs/games/legends-of-runeterra {
      inherit umu mangohud;
      location = "/media/BigData/Games/legends-of-runeterra";
    })
  ];
}
