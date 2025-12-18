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
    ${lib.getExe inputs.rb-scrobbler.packages.${pkgs.stdenv.hostPlatform.system}.default} -n "keep" -o -4 $@
  '';
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
      owner = "tunnel";
      group = "users";
    };
    "lastfm" = {
      file = "${inputs.secrets}/media/qtscrob.age";
      mode = "400";
      owner = "tunnel";
      group = "users";
    };
  };
  services.playerctld.enable = true;
  environment.systemPackages = [
    inputs.khinsider.packages.${pkgs.stdenv.hostPlatform.system}.default
    playlist-download.default
    playlist-download.rb-scrob
    lastfm-wrapped
    rockbox-database
    # self.packages.${pkgs.stdenv.hostPlatform.system}.bandcamp-dl

    (pkgs.writeShellApplication {
      name = "ipod-sync";
      runtimeInputs = [
        pkgs.rsync
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
          rsync -vh --modify-window=1 --update --recursive --times --info=progress2 --no-inc-recursive "/media/Data/TranscodedMusic/" "''${IPOD_DIR}/"
        fi
      '';
    })
    # TODO this was written by someone who didn't want to put any time or thought into writing something maintainable. i hate every part of it.
    (pkgs.writeShellApplication {
      name = "monthly-copy";
      runtimeInputs = [
        pkgs.ffmpeg
        pkgs.gum
      ];
      text = ''
        PLAYLIST=$(gum file "$PLAYLIST_DIR" --no-permissions --no-size)
        # PLAYLIST=''${2:-"$OUTPUT_PLAYLIST_DIR/monthly playlist.m3u8"}
        DEST_FOLDER=''${1}
        while IFS= read -r line; do
          [[ $line == \#* ]] || [[ -z $line ]] && continue
          song_file=$(basename "$line")
          extension="''${song_file##*.}"
          if [[ "$extension" == "flac" ]] || [[ "$extension" == "alac" ]]; then
            # ffmpeg -nostdin -i "$line" -aq 2 "$DEST_FOLDER/''${song_file%.*}.mp3"
            ffmpeg -nostdin -i "$line" -ab 320k "$DEST_FOLDER/''${song_file%.*}.mp3"
          else
            cp "$line" "$DEST_FOLDER/" 2> /dev/null
            continue
          fi
        done < "$PLAYLIST"
      '';
    })
  ];
}
