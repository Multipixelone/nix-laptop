{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  winetricks,
  wine,
  wineFlags ? "",
  pname ? "soundshow-win",
  location ? "$HOME/.soundshow-wine",
  wineDllOverrides ? [ "winemenubuilder.exe=d" ],
  preCommands ? "",
  postCommands ? "",
  pkgs,
}:
let
  version = "2026.02.05";

  src = pkgs.fetchurl {
    url = "https://github.com/soundshow-app/soundshow-downloads/releases/download/v${version}/SoundShow-win-x64.zip";
    hash = "sha256-dGpnGWWpRFtTB3Cfy1F9Uff48XpSQ0WmfyyBlXiuWlM=";
  };

  script = writeShellScriptBin pname ''
    export WINEARCH="win64"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${location}"
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep ";" wineDllOverrides}"
    export WINEDEBUG=-all

    PATH=${
      lib.makeBinPath [
        wine
        winetricks
      ]
    }:$PATH
    SOUNDSHOW_DIR="$WINEPREFIX/drive_c/SoundShow"
    SOUNDSHOW_BIN="$SOUNDSHOW_DIR/SoundShow.exe"

    if [ ! -e "$SOUNDSHOW_BIN" ]; then
      mkdir -p "$WINEPREFIX/drive_c"
      ${pkgs.unzip}/bin/unzip -o "${src}" -d "$WINEPREFIX/drive_c/"
    fi

    cd "$WINEPREFIX"

    ${preCommands}

    wine ${wineFlags} "$SOUNDSHOW_BIN" "$@"
    wineserver -w

    ${postCommands}
  '';

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    comment = "SoundShow (Wine)";
    desktopName = "SoundShow (Wine)";
    categories = [ "Audio" ];
  };
in
symlinkJoin {
  name = pname;
  paths = [
    desktopItems
    script
  ];

  meta = {
    description = "Soundboard and multimedia player for live triggering audio cues (Windows version via Wine)";
    homepage = "https://soundshow.app";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ Multipixelone ];
    platforms = [ "x86_64-linux" ];
  };
}
