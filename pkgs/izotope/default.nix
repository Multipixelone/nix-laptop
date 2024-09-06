{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  winetricks,
  wine,
  wineFlags ? "",
  pname ? "izotope-rx-10",
  location ? "$HOME/.wine",
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
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep "," wineDllOverrides}"
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
    GAME_PATH="$WINEPREFIX/drive_c/Program Files/iZotope/RX Pro Audio Editor/win64"
    GAME_BIN="$GAME_PATH/iZotope RX 10 Audio Editor.exe"

    # EAC Fix
    if [ -d "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat" ]
    then
      rm -rf "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat";
    fi

    ${preCommands}

    wine ${wineFlags} "$GAME_BIN" "$@"

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
    desktopName = "iZotope RX 10 Pro Audio Editor";
    categories = ["Audio"];
    mimeTypes = [
      "audio/basic"
      "audio/x-aiff"
      "audio/x-wav"
      "audio/x-ms-wma"
      "audio/x-flac"
      "audio/x-forbis+ogg"
      "audio/flac"
      "audio/aac"
      "audio/ac3"
      "audio/mp4"
      "audio/mpeg"
      "application/ogg"
    ];
  };
in
  symlinkJoin {
    name = pname;
    paths = [
      desktopItems
      script
    ];

    meta = {
      description = "iZotope RX audio repair toolkit";
      homepage = "https://www.izotope.com/en/products/rx.html";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [Multipixelone];
      platforms = ["x86_64-linux"];
    };
  }
