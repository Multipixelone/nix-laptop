{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: let
  umu = inputs.umu.packages.${pkgs.system}.umu;
  mangohud = config.programs.mangohud.package;
in {
  imports = [
    ./mangohud.nix
    ./moondeck.nix
  ];
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "optifine"
    ];
  home.packages = with pkgs; [
    gamescope
    lutris
    gamemode
    steamtinkerlaunch
    prismlauncher
    cemu
    amdgpu_top
    optifinePackages.optifine_1_20_4
    # custom pablomk7 citra (https://github.com/Pengiie/nix-flake/blob/ba643e26cefd99a5934c5b96da789820a1e90e5d/users/modules/citra/default.nix)
    (callPackage ../../../pkgs/games/citra {})
    # Custom umu game runners
    # (callPackage ../../../pkgs/games/cities-skylines-2 {
    #   inherit umu mangohud;
    #   location = "/media/TeraData/Games/cities-skylines-ii";
    # })
    # (callPackage ../../../pkgs/games/silent-hill-2 {
    #   inherit umu mangohud;
    #   location = "/media/BigData/Games/silent-hill-2-directors-cut";
    # })
    (callPackage ../../../pkgs/games/legends-of-runeterra {
      inherit umu mangohud;
      location = "/media/BigData/Games/legends-of-runeterra";
    })
    # (callPackage ../../../pkgs/games/gw2 {
    #   inherit umu mangohud;
    #   exe = "/media/BigData/Games/SteamLibrary/steamapps/common/Guild Wars 2";
    #   location = "/media/BigData/Games/SteamLibrary/steamapps/compatdata/1284210/pfx";
    # })
    (callPackage ../../../pkgs/games/bookworm-adventures {
      wine = pkgs.wine;
    })
  ];
}
