{
  pkgs,
  inputs,
  config,
  ...
}: let
  umu = pkgs.umu-launcher;
  mangohud = config.programs.mangohud.package;
  retroarch-cores = pkgs.retroarch.withCores (
    cores:
      with cores; [
        gambatte
        gpsp
        melonds
        mupen64plus
        pcsx-rearmed
        pcsx2
        ppsspp
        snes9x
        bsnes
      ]
  );
in {
  imports = [
    ./mangohud.nix
    # ./moondeck.nix
  ];
  home.packages = with pkgs; [
    prismlauncher
    amdgpu_top
    vulkan-tools
    vulkan-loader
    inputs.nix-gaming.packages.${pkgs.system}.mo2installer
    umu
    protontricks
    zenity
    retroarch-cores
    # custom pablomk7 citra (https://github.com/Pengiie/nix-flake/blob/ba643e26cefd99a5934c5b96da789820a1e90e5d/users/modules/citra/default.nix)
    # (callPackage ../../../pkgs/games/citra {})
    # Custom umu game runners
    # (callPackage ../../../pkgs/games/until-dawn {
    #   inherit umu mangohud;
    #   location = "/media/TeraData/Games/until-dawn";
    # })
    # (callPackage ../../../pkgs/games/silent-hill-2 {
    #   inherit umu mangohud;
    #   location = "/media/BigData/Games/silent-hill-2-directors-cut";
    # })
    (callPackage ../../../pkgs/games/legends-of-runeterra {
      inherit umu mangohud;
      location = "/media/BigData/Games/legends-of-runeterra";
    })
    (callPackage ../../../pkgs/games/gw2 {
      inherit umu;
      exe = "/media/BigData/Games/SteamLibrary/steamapps/common/Guild Wars 2";
      location = "/media/BigData/Games/SteamLibrary/steamapps/compatdata/1284210/pfx";
    })
    # (callPackage ../../../pkgs/games/bookworm-adventures {
    #   wine = pkgs.wine;
    # })
  ];
}
