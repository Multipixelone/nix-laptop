{
  pkgs,
  inputs,
  ...
}: {
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
    # TODO make these something better than jank shell scripts
    # WINE SHELL RUNNERS! :)
    (writeShellApplication {
      name = "cities-skylines-2";
      runtimeInputs = [inputs.nix-gaming.packages.${pkgs.system}.wine-tkg];
      text = ''
        export WINEPREFIX=/media/TeraData/Games/cities-skylines-ii
        wine "$WINEPREFIX/drive_c/Program Files/Cities Skylines II/Cities2.exe"
      '';
    })
  ];
}
