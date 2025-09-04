{
  pkgs,
  self,
  lib,
  config,
  inputs,
  ...
}: let
  playlist-download = inputs.playlist-download.packages.${pkgs.system}.default;
in {
  age.secrets = {
    "plex" = {
      file = "${inputs.secrets}/media/plextoken.age";
      mode = "400";
      owner = "tunnel";
      group = "users";
    };
    "qtscrob" = {
      file = "${inputs.secrets}/media/qtscrob.age";
      mode = "400";
      owner = "tunnel";
      group = "users";
    };
  };
  services.playerctld.enable = true;
  systemd.timers."playlist-downloader" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      # every three hrs
      OnCalendar = "00/3:00";
      Persistent = true;
      RandomizedDelaySec = "20m";
    };
  };
  systemd.services."playlist-downloader" = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = lib.getExe playlist-download;
      User = "tunnel";
    };
  };
  environment.systemPackages = [
    inputs.khinsider.packages.${pkgs.system}.default
    inputs.qtscrob.packages.${pkgs.system}.default
    playlist-download
    # self.packages.${pkgs.system}.bandcamp-dl

    (pkgs.writeShellApplication {
      name = "ipod-sync";
      runtimeInputs = [pkgs.rsync];
      text = ''
        SCROB_CONFIG_FILE=${config.age.secrets."qtscrob".path}
        if [ -d "$IPOD_DIR" ]; then
          scrobbler -c "$SCROB_CONFIG_FILE" -f -l "$IPOD_DIR"
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
      runtimeInputs = [pkgs.ffmpeg pkgs.gum];
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
