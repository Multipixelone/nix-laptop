{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  gamemode,
  mangohud,
  winetricks,
  wine,
  dxvk,
  wineFlags ? "",
  pname ? "stray",
  location ? "$HOME/Games/stray",
  tricks ? [],
  wineDllOverrides ? ["powershell.exe=n"],
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pkgs,
}: let
  version = "1.6.10";
  src = pkgs.fetchurl {
    url = "https://install.robertsspaceindustries.com/star-citizen/RSI-Setup-${version}.exe";
    name = "RSI-Setup-${version}.exe";
    hash = "sha256-axttJvw3MFmhLC4e+aqtf4qx0Z0x4vz78LElyGkMAbs=";
  };

  # concat winetricks args
  tricksFmt = with builtins;
    if (length tricks) > 0
    then concatStringsSep " " tricks
    else "-V";

  script = writeShellScriptBin pname ''
    export WINEARCH="win64"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${location}"
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep "," wineDllOverrides}"
    # ID for umu, not used for now
    export GAMEID="umu-stray"
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

    PATH=${lib.makeBinPath [wine winetricks]}:$PATH
    USER="$(whoami)"
    GAME_BIN="$WINEPREFIX/drive_c/Stray/Hk_project/Binaries/Win64/Stray-Win64-Shipping.exe"

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksFmt}
      wineserver -k

      mkdir -p "$WINEPREFIX/drive_c/Stray/Hk_project/Binaries/Win64/"

      # install launcher
      # Use silent install
      wine ${src} /S

      wineserver -k
    fi

    # EAC Fix
    if [ -d "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat" ]
    then
      rm -rf "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat";
    fi
    cd $WINEPREFIX

    ${dxvk}/bin/setup_dxvk.sh install --symlink

    ${preCommands}

    ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud wine ${wineFlags} "$GAME_BIN" "$@"
    wineserver -w

    ${postCommands}
  '';

  icon = pkgs.fetchurl {
    # Source: https://www.steamgriddb.com/icon/12780
    url = "https://cdn2.steamgriddb.com/icon/f7bbcc6ef14fd79655f09efb14b99316.png";
    hash = "sha256-YHSIeSYq3h71PSp7A/TamVgYas2BDmoLl/LJAkhmksc=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    inherit icon;
    desktopName = "Stray";
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
      description = "Stray game wine launcher";
      homepage = "https://stray.game/";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [Multipixelone];
      platforms = ["x86_64-linux"];
    };
  }
