{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  playlist-download = inputs.playlist-download.packages.${pkgs.stdenv.hostPlatform.system};
  # wrap secret into lastfm scrobbler
  lastfm-wrapped = pkgs.writeShellScriptBin "rb-scrobbler" ''
    set -o allexport
    source ${config.age.secrets."lastfm".path}
    ${
      lib.getExe inputs.rb-scrobbler.packages.${pkgs.stdenv.hostPlatform.system}.default
    } -n "keep" -o -4 $@
  '';
  rclone-config = pkgs.writeText "rclone-ipod.conf" ''
    [ipod_disk]
    type = local
    nounc = true

    [ipod_hasher]
    type = hasher
    remote = ipod_disk:${config.home.sessionVariables.IPOD_DIR}
    db_path = ${config.xdg.cacheHome}/rclone/ipod_hasher.db
    max_age = off
  '';
  rclone-wrapped = pkgs.writeShellScriptBin "rclone" ''
    ${lib.getExe pkgs.rclone} --config="${rclone-config}" $@
  '';
  ipod-sync = pkgs.writeShellApplication {
    name = "ipod-sync";
    runtimeInputs = [
      pkgs.rsync
      rclone-wrapped
      playlist-download.rb-scrob
      lastfm-wrapped
    ];
    text = ''
      if [ -d "$IPOD_DIR" ]; then
        systemctl --user start transcode-music playlist-downloader
        if [ -f "$IPOD_DIR/.rockbox/playback.log" ]; then
          LOG_FILE="$(rb-parse)"
          rb-scrobbler -f "''${LOG_FILE}"
        fi
        rsync -vh --modify-window=1 --exclude="*.csv" --update --recursive --times --info=progress2 --no-inc-recursive "/volume1/Media/RockboxCover/" "''${IPOD_DIR}/.rockbox/albumart/" || true
        echo "Syncing playlists..."
        rsync -vh --modify-window=1 --exclude="*.csv" --update --recursive --times --info=progress2 --no-inc-recursive "''${PLAYLIST_DIR}/.ipod/" "''${IPOD_DIR}/Playlists/" || true
        echo "Syncing music..."
        rclone sync "/media/Data/TranscodedMusic/" "ipod_hasher:/" \
          --checksum \
          --buffer-size 0 \
          --transfers 1 \
          --checkers 4 \
          --progress
      fi
    '';
  };

  # TODO do this. literally any other way. this is dependent on so many external things its not even funny
  rockbox-database = pkgs.writeShellApplication {
    name = "rockbox-database";
    runtimeInputs = [
      pkgs.podman
    ];
    text = ''
      DAP_ROOT_FOLDER=/volume1/Media/TranscodedMusic
      SRC_FOLDER_PATH=/home/tunnel/Documents/Git/rockbox-docker/rockbox-git
      podman run --rm -v "$SRC_FOLDER_PATH":/usr/src/rockbox -v "$DAP_ROOT_FOLDER":/mnt/dap --name rockboxdatabaserool$((RANDOM)) localhost/rockbox:latest /usr/src/rockbox/databasetool.sh
    '';
  };
in
{
  age.secrets = {
    "plex" = {
      file = "${inputs.secrets}/media/plextoken.age";
      mode = "400";
    };
    "lastfm" = {
      file = "${inputs.secrets}/media/qtscrob.age";
      mode = "400";
    };
  };
  home.packages = [
    playlist-download.default
    playlist-download.rb-scrob

    lastfm-wrapped
    rockbox-database

    ipod-sync
    rclone-wrapped
  ];
}
