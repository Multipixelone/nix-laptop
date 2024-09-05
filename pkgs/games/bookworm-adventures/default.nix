{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  mangohud,
  winetricks,
  umu,
  proton ? "GE-Proton",
  wineFlags ? "",
  pname ? "bookworm-adventures",
  location ? "$HOME/Games/bookworm-adventures",
  tricks ? ["winxp"],
  wineDllOverrides ? ["powershell.exe=n"],
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pkgs,
}: let
  src = pkgs.fetchzip {
    url = "https://archive.org/download/bookworm_adventures_deluxe/Bookworm%20Adventures%20Deluxe.zip";
    hash = "sha256-WZKM1NpQ33V/7rBzq5DfLmIs+BSIMUJTylbjzMneYDU=";
  };

  # concat winetricks args
  tricksFmt = with builtins;
    if (length tricks) > 0
    then concatStringsSep " " tricks
    else "-V";

  script = writeShellScriptBin pname ''
    export WINEARCH="win32"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${location}"
    export PROTONPATH="${proton}"
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep "," wineDllOverrides}"
    # ID for umu, not used for now
    export GAMEID="umu-3470"
    export STORE="none"
    # Anti-cheat
    export EOS_USE_ANTICHEATCLIENTNULL=1
    # Nvidia tweaks
    export WINE_HIDE_NVIDIA_GPU=1
    export __GL_SHADER_DISK_CACHE=${
      if enableGlCache
      then "1"
      else "0"
    }
    export __GL_SHADER_DISK_CACHE_SIZE=${toString glCacheSize}
    export WINE_HIDE_NVIDIA_GPU=1
    # AMD
    export dual_color_blend_by_location=1

    PATH=${lib.makeBinPath [umu winetricks]}:$PATH
    USER="$(whoami)"
    GAME_PATH="$WINEPREFIX/drive_c/Games/Bookworm Adventures Deluxe"
    GAME_BIN="$GAME_PATH/BookwormAdventures.exe"

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksFmt}
      mkdir -p "$WINEPREFIX/drive_c/Games/"

      # install launcher
      # Copy source folder into drive_c/Games
      cp -r "${src}/Bookworm Adventures Deluxe" "$WINEPREFIX/drive_c/Games/"
    fi

    cd $WINEPREFIX

    ${preCommands}

    ${mangohud}/bin/mangohud umu-run ${wineFlags} "$GAME_BIN" "$@"

    ${postCommands}
  '';

  icon = pkgs.fetchurl {
    # Source: https://www.steamgriddb.com/icon/64381
    url = "https://cdn2.steamgriddb.com/icon/9bf2f59888976ef90dc2bd083d0a4cb5.ico";
    hash = "sha256-PZQ87NHDBcYkTqOag1CYug2Ux8xOIhNzkgGO32OjR3o=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    inherit icon;
    desktopName = "Bookworm Adventures Deluxe";
    categories = ["Game"];
  };
in
  symlinkJoin {
    name = pname;
    paths = [
      desktopItems
      script
    ];

    meta = {
      description = "Bookworm Adventures Deluxe is a word-forming puzzle video game, the follow-up to Bookworm from PopCap Games.";
      homepage = "https://archive.org/details/bookworm_adventures_deluxe";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [Multipixelone];
      platforms = ["x86_64-linux"];
    };
  }
