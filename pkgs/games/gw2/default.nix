{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  gamemode,
  mangohud,
  winetricks,
  umu,
  proton ? "GE-Proton",
  dxvk,
  wineFlags ? "",
  pname ? "gw2",
  location ? "$HOME/Games/cities-skylines-ii",
  exe,
  wineDllOverrides ? ["powershell.exe=n"],
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pkgs,
}: let

  # concat winetricks args

  script = writeShellScriptBin pname ''
    export WINEARCH="win64"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${location}"
    export GAME_PATH="${exe}"
    export PROTONPATH="${proton}"
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep "," wineDllOverrides}"
    # ID for umu, not used for now
    export GAMEID="umu-cities-skylines-ii"
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
    GAME_BIN="$GAME_PATH/Gw2-64.exe"
    BLISH="$GAME_PATH/Blish HUD.exe"

    # EAC Fix
    if [ -d "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat" ]
    then
      rm -rf "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat";
    fi
    cd $WINEPREFIX

    #${dxvk}/bin/setup_dxvk.sh install --symlink

    #${preCommands}

    ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud umu-run ${wineFlags} "$GAME_BIN" "$@" &
    sleep 30
    umu-run ${wineFlags} "$BLISH" "$@"

    ${postCommands}
  '';

  icon = pkgs.fetchurl {
    # Source: https://www.steamgriddb.com/icon/45742
    url = "https://cdn2.steamgriddb.com/icon/ecf779950797b04af59fb80a6f81aa2c.png";
    hash = "sha256-qHRF5T8hkjJWrXT6G9+HcQ2uuHS+i50aV4+IDuyNzAc=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    inherit icon;
    desktopName = "Guild Wars II";
    categories = ["Game"];
    # mimeTypes = ["application/x-star-citizen-launcher"];
  };
in
  symlinkJoin {
    name = pname;
    paths = [
      desktopItems
      script
    ];

    meta = {
      description = "Cities Skylines II game wine launcher";
      homepage = "https://www.paradoxinteractive.com/games/cities-skylines-ii/about";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [Multipixelone];
      platforms = ["x86_64-linux"];
    };
  }
