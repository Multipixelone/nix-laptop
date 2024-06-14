{
  pkgs,
  config,
  inputs,
  ...
}: {
  age.secrets = {
    "plex" = {
      file = "${inputs.secrets}/media/plextoken.age";
      mode = "770";
      owner = "tunnel";
      group = "users";
    };
    "qtscrob" = {
      file = "${inputs.secrets}/media/qtscrob.age";
      mode = "770";
      owner = "tunnel";
      group = "users";
    };
  };
  systemd.timers."playlist-downloader" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "20m";
    };
  };
  systemd.services."playlist-downloader" = {
    path = [pkgs.rsync pkgs.curl pkgs.xmlstarlet pkgs.jq pkgs.gawk];
    script = ''
      urlencode() {
        local string="''${1}"
        local encoded=""

        encoded=$(printf %s "''${string}" | jq -sRr @uri | sed 's/%2F/\//g')
        echo "''${encoded}"
      }
      convert_filename() {
        local original_filename="$1"
        local trimmed_filename="''${original_filename#/media/Data/Music/}"
        local encoded_filename
        encoded_filename=$(urlencode "$trimmed_filename")
        local final_filename="local:track:$encoded_filename"
        echo "$final_filename"
      }

      OUTPUT_PLAYLIST_DIR="/home/tunnel/Music/Playlists"
      MOPIDY_PLAYLISTS_DIR="/home/tunnel/.local/share/mopidy/m3u"
      IPOD_PLAYLISTS_DIR="/home/tunnel/Music/.ipod"
      MUSIC_DIR="/media/Data/Music"
      SECRET_FILE=${config.age.secrets."plex".path}
      read -r PLEX_TOKEN < "$SECRET_FILE"

      playlist_names=( "monthly playlist" "forgotten faves" "good listening and learning" "slipped through" "vgm study" "amtrak" "mackin mabel" "summer jams" )
      playlist_ids=( "24562" "48614" "20340" "26220" "53423" "26224" "61577" "61792" )
      length=''${#playlist_names[@]}

      for (( i=0; i < length; i++ )); do
        name="''${playlist_names[$i]}"
        playlist_id="''${playlist_ids[$i]}"
        output_file="''${name}.m3u8"
        output_path="''${OUTPUT_PLAYLIST_DIR}/$output_file"
        mopidy_path="''${MOPIDY_PLAYLISTS_DIR}/$output_file"
        ipod_path="''${IPOD_PLAYLISTS_DIR}/$output_file"

        echo "downloading $name"
        curl http://alexandria:32400/playlists/"$playlist_id"/items?X-Plex-Token="$PLEX_TOKEN" | xmlstarlet sel -t -v '//Track/Media/Part/@file' -n | sed 's/amp;//g' | awk 'BEGIN { print "#EXTM3U" } { gsub("/volume1/Media/Music", "'"$MUSIC_DIR"'", $0); print }' > "$output_path"
        echo "saved to $output_path"
        sed 's/\/media\/Data\/Music//g' "$output_path" > "$ipod_path"
        echo "saved to $ipod_path"
        rm -f "$mopidy_path"
        while IFS= read -r line; do
          processed_line=$(convert_filename "$line")
          echo "$processed_line" >> "$mopidy_path"
        done < <(tail -n +2 "$output_path")  # Read from the file, skipping the first line
        echo "saved to $mopidy_path"
      done
      echo "all playlists downloaded & saved to $OUTPUT_PLAYLIST_DIR, $MOPIDY_PLAYLISTS_DIR, and $IPOD_PLAYLISTS_DIR"
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "tunnel";
    };
  };
  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "ipod-sync";
      runtimeInputs = [pkgs.rsync];
      text = ''
        IPOD_DIR="/run/media/tunnel/FINNR_S IPO"
        IPOD_PLAYLISTS_DIR="/home/tunnel/Music/.ipod"
        MUSIC_DIR="/media/Data/Music"
        SCROB_CONFIG_FILE=${config.age.secrets."qtscrob".path}
        if [ -d "$IPOD_DIR" ]; then
          scrobbler -c "$SCROB_CONFIG_FILE" -f -l "$IPOD_DIR"
          rsync -vh --modify-window=1 --exclude="*.csv" --update --recursive --times --info=progress2 --no-inc-recursive "''${IPOD_PLAYLISTS_DIR}/" "''${IPOD_DIR}/Playlists/"
          echo "Playlists synced. Syncing music..."
          rsync -vh --modify-window=1 --update --recursive --times --info=progress2 --no-inc-recursive "''${MUSIC_DIR}/" "''${IPOD_DIR}/"
        fi
      '';
    })
    # TODO this was written by someone who didn't want to put any time or thought into writing something maintainable. i hate every part of it.
    (pkgs.writeShellApplication {
      name = "monthly-copy";
      runtimeInputs = [pkgs.ffmpeg];
      text = ''
        OUTPUT_PLAYLIST_DIR="/home/tunnel/Music/Playlists"
        PLAYLIST="$OUTPUT_PLAYLIST_DIR/monthly playlist.m3u8"
        DEST_FOLDER=''${1}
        while IFS= read -r line; do
          [[ $line == \#* ]] || [[ -z $line ]] && continue
          song_file=$(basename "$line")
          extension="''${song_file##*.}"
          if [[ "$extension" == "flac" ]] || [[ "$extension" == "alac" ]]; then
            ffmpeg -nostdin -i "$line" -aq 2 "$DEST_FOLDER/''${song_file%.*}.mp3"
            # ffmpeg -nostdin -i "$line" -ab 320k "$DEST_FOLDER/''${song_file%.*}.mp3"
          else
            # mv "$line" "$DEST_FOLDER/" 2> /dev/null
            continue
          fi
        done < "$PLAYLIST"
      '';
    })
  ];
}
