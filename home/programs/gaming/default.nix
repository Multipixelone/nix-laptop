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
    (callPackage ../../../pkgs/games/stray/default.nix {
      inherit wine mangohud;
      location = "/media/TeraData/Games/stray";
    })
  ];
  # TODO make these into proper wine packages copying from nix-gaming
  # WINE SHELL RUNNERS! :)
  xdg.desktopEntries = {
    cities-skylines-2 = {
      name = "Cities Skylines II";
      exec =
        pkgs.writeShellApplication {
          name = "cities-skylines-2";
          runtimeInputs = [pkgs.gamemode config.programs.mangohud.package inputs.nix-gaming.packages.${pkgs.system}.wine-tkg];
          text = ''
            export WINEPREFIX=/media/TeraData/Games/cities-skylines-ii
            gamemoderun mangohud wine "$WINEPREFIX/drive_c/Program Files/Cities Skylines II/Cities2.exe"
          '';
        }
        + "/bin/cities-skylines-2";
      terminal = false;
      type = "Application";
      categories = ["Game"];
    };
  };
}
