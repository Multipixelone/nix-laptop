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
    stray = {
      name = "Stray";
      exec =
        pkgs.writeShellApplication {
          name = "stray";
          runtimeInputs = [inputs.nix-gaming.packages.${pkgs.system}.wine-ge];
          text = ''
            export WINEPREFIX=/media/TeraData/Games/stray
            gamemoderun mangohud wine "$WINEPREFIX/drive_c/Stray/Hk_project/Binaries/Win64/Stray-Win64-Shipping.exe"
          '';
        }
        + "/bin/stray";
      terminal = false;
      type = "Application";
      categories = ["Game"];
    };
  };
}
