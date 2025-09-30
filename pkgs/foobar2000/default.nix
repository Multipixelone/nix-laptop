{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  winetricks,
  wine,
  wineFlags ? "",
  pname ? "foobar2000",
  location ? "$HOME/.local/share/foobar2000",
  tricks ? [ ],
  wineDllOverrides ? [ "powershell.exe=n" ],
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pkgs,
}:
let
  version = "2.1.5";
  src = pkgs.fetchurl {
    url = "https://www.foobar2000.org/files/foobar2000_v${version}.exe";
    name = "foobar_${version}.exe";
    hash = "sha256-O0ofWpn3BA/yNaamEEX7GHey5kamohqc60cqXmBtvVU=";
  };
  eole = pkgs.fetchFromGitHub {
    owner = "Ottodix";
    repo = "Eole-foobar-theme";
    rev = "v1.2.3b23";
    hash = "sha256-tjBK8NBnxmg4Ej+c/6SezA7OkVS7dT84c4vzZf11yJY=";
  };
  # concat winetricks args
  tricksFmt = with builtins; if (length tricks) > 0 then concatStringsSep " " tricks else "-V";

  script = writeShellScriptBin pname ''
    export WINEARCH="win32"
    export WINEFSYNC=1
    export WINEESYNC=1
    export WINEPREFIX="${location}"
    export WINEDLLOVERRIDES="${lib.strings.concatStringsSep "," wineDllOverrides}"
    # Nvidia tweaks
    export WINE_HIDE_NVIDIA_GPU=1
    export __GL_SHADER_DISK_CACHE=${if enableGlCache then "1" else "0"}
    export __GL_SHADER_DISK_CACHE_SIZE=${toString glCacheSize}
    export WINE_HIDE_NVIDIA_GPU=1
    # AMD
    export dual_color_blend_by_location=1

    PATH=${
      lib.makeBinPath [
        wine
        winetricks
      ]
    }:$PATH
    USER="$(whoami)"
    GAME_PATH="$WINEPREFIX/drive_c/Program Files/foobar2000"
    GAME_BIN="$GAME_PATH/foobar2000.exe"
    PROFILE_PATH="$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/foobar2000-v2"

    # EAC Fix
    if [ -d "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat" ]
    then
      rm -rf "$WINEPREFIX/drive_c/users/$USER/AppData/Roaming/EasyAntiCheat";
    fi

    if [ ! -d "$WINEPREFIX" ]; then
      # install tricks
      winetricks -q -f ${tricksFmt}
      mkdir -p "$GAME_PATH"

      # install launcher
      # Use silent install
      wine ${src}
    fi
    ${preCommands}

    cp -r ${eole}/user-components $PROFILE_PATH/
    cp -r ${eole}/themes $PROFILE_PATH/
    cp -r ${eole}/plugins $PROFILE_PATH/
    wine ${wineFlags} "$GAME_BIN" "$@"
    echo ${eole}

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
    desktopName = "foobar2000";
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
    maintainers = with lib.maintainers; [ Multipixelone ];
    platforms = [ "x86_64-linux" ];
  };
}
