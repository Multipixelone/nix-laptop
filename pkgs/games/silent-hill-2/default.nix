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
  wineFlags ? "",
  pname ? "silent-hill-2",
  location ? "$HOME/Games/silent-hill-2",
  tricks ? [ ],
  wineDllOverrides ? [ "powershell.exe=n" ],
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pkgs,
}:
let
  version = "1.6.10";
  src = pkgs.fetchurl {
    url = "https://install.robertsspaceindustries.com/star-citizen/RSI-Setup-${version}.exe";
    name = "RSI-Setup-${version}.exe";
    hash = "sha256-axttJvw3MFmhLC4e+aqtf4qx0Z0x4vz78LElyGkMAbs=";
  };

  # concat winetricks args
  tricksFmt = with builtins; if (length tricks) > 0 then concatStringsSep " " tricks else "-V";

  script = writeShellScriptBin pname ''
    export WINEARCH="win64"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${location}"
    export PROTONPATH="${proton}"
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep "," wineDllOverrides}"
    # ID for umu, not used for now
    export GAMEID="umu-silent-hill-2"
    export STORE="none"
    # Anti-cheat
    export EOS_USE_ANTICHEATCLIENTNULL=1
    # Nvidia tweaks
    export WINE_HIDE_NVIDIA_GPU=1
    export __GL_SHADER_DISK_CACHE=${if enableGlCache then "1" else "0"}
    export __GL_SHADER_DISK_CACHE_SIZE=${toString glCacheSize}
    export WINE_HIDE_NVIDIA_GPU=1
    # AMD
    export dual_color_blend_by_location=1

    PATH=${
      lib.makeBinPath [
        umu
        winetricks
      ]
    }:$PATH
    USER="$(whoami)"
    GAME_PATH="$WINEPREFIX/drive_c/Program Files (x86)/Konami/Silent Hill 2 - Directors Cut"
    GAME_BIN="$GAME_PATH/sh2pc.exe"

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksFmt}
      mkdir -p "$GAME_PATH"

      # install launcher
      # Use silent install
      umu-run ${src} /S
    fi

    # EAC Fix
    if [ -d "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat" ]
    then
      rm -rf "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat";
    fi
    cd $WINEPREFIX

    ${preCommands}

    ${gamemode}/bin/gamemoderun ${mangohud}/bin/mangohud umu-run ${wineFlags} "$GAME_BIN" "$@"

    ${postCommands}
  '';

  icon = pkgs.fetchurl {
    # Source: https://www.steamgriddb.com/icon/53051
    url = "https://cdn2.steamgriddb.com/icon/82d693875bfe7c93f77f612ddf1f46eb.png";
    hash = "sha256-z67XDfjd3YVSq1D7ZH75dxgg1FhCkU5JuvORqEbU570=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    inherit icon;
    desktopName = "Silent Hill 2: Director's Cut";
    categories = [ "Game" ];
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
    description = "Silent Hill 2 Enhanced Edition Launcher";
    homepage = "https://enhanced.townofsilenthill.com/SH2";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Multipixelone ];
    platforms = [ "x86_64-linux" ];
  };
}
