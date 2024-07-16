{
  lib,
  makeDesktopItem,
  symlinkJoin,
  writeShellScriptBin,
  mangohud,
  gamescope,
  winetricks,
  umu,
  proton ? "GE-Proton",
  wineFlags ? "",
  pname ? "legends-of-runeterra",
  location ? "$HOME/Games/legends-of-runeterra",
  tricks ? [],
  wineDllOverrides ? ["powershell.exe=n"],
  preCommands ? "",
  postCommands ? "",
  enableGlCache ? true,
  glCacheSize ? 1073741824,
  pkgs,
}: let
  version = "live";
  src = pkgs.fetchurl {
    url = "https://bacon.secure.dyn.riotcdn.net/channels/public/x/installer/current/${version}.${version}.americas.exe";
    name = "LOR.exe";
    hash = "sha256-88NaOgUpQtamW9UCBDJyf6FkNUo2d0501dl33+PUDms=";
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
    GAME_PATH="$WINEPREFIX/drive_c/Riot Games/Riot Client"
    GAME_BIN="$GAME_PATH/RiotClientServices.exe -- --launch-product=bacon --launch-patchline=${version}"

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

    ${gamescope}/bin/gamescope -w 2560 -h 1440 -- ${mangohud}/bin/mangohud umu-run ${wineFlags} "$GAME_BIN" "$@"

    ${postCommands}
  '';

  icon = pkgs.fetchurl {
    # Source: https://www.steamgriddb.com/icon/15152
    url = "https://cdn2.steamgriddb.com/icon/dff4ba680e945e400d3d800a9fa29f3e.png";
    hash = "sha256-zb85q8AJE44sjEJ6qrmxLYIM1PchfBzi68fx5gfoyZQ=";
  };

  desktopItems = makeDesktopItem {
    name = pname;
    exec = "${script}/bin/${pname} %U";
    inherit icon;
    desktopName = "Legends of Runeterra";
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
      description = "Legends of Runeterra game wine launcher";
      homepage = "https://playruneterra.com/en-us/";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [Multipixelone];
      platforms = ["x86_64-linux"];
    };
  }
