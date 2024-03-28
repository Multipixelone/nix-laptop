{pkgs}:
pkgs.writeShellApplication {
  name = "ipod-sync";

  runtimeInputs = [pkgs.rsync];

  text = ''
    OUTPUT_PLAYLIST_DIR="/home/tunnel/Music/Playlists"
    EXPORT_PLAYLIST_DIR="/home/tunnel/Music/WebTools-NG/ExportTools"
    #MUSIC_DIR="/media/Data/Music"
    #IPOD_DIR="/run/media/tunnel/FINNR_S IPO"
    cd $EXPORT_PLAYLIST_DIR
    for FILE in *.csv; do
        # Skip if it's a directory
        if [ -d "$FILE" ]; then
            continue
        fi

        # Extract the specific part of the file name
        FILENAME_PART=$(echo "$FILE" | sed -n 's/alexandria_\(.*\)_Playlist.*/\1/p')

        # Remove the last three characters before the period
        FILENAME_PART=''${FILENAME_PART%???}

        # Output file with .m3u8 extension
        OUTPUT_FILE="''${FILENAME_PART}.m3u8"

        # Process the file and save in the current directory
        awk -F '|' 'BEGIN { print "#EXTM3U" } NR>1 { gsub("/volume1/Media/Music", "", $25); gsub("\"", "", $25); print $25 }' "$FILE" > "$OUTPUT_FILE"

        # Modify the paths and save in the Playlists directory
        sed 's@^/@/media/Data/Music/@' "$OUTPUT_FILE" > "''${OUTPUT_PLAYLIST_DIR}/''${OUTPUT_FILE}"

        echo "Processed $FILE -> $OUTPUT_FILE"
        echo "Playlist also saved to ''${OUTPUT_PLAYLIST_DIR}/''${OUTPUT_FILE}"
    done

    rm -f ./*.csv
    echo "CSV files cleaned up."
    echo "All Playlists exported to ''${EXPORT_PLAYLIST_DIR} and ''${OUTPUT_PLAYLIST_DIR}. Time to sync :)"
    #rsync -vh --modify-window=1 --exclude="*.csv" --update --recursive --times --info=progress2 --no-inc-recursive "''${EXPORT_PLAYLIST_DIR}/" "''${IPOD_DIR}/Playlists/"
    #echo "Playlists synced. Syncing music..."
    #rsync -vh --modify-window=1 --update --recursive --times --info=progress2 --no-inc-recursive "''${MUSIC_DIR}/" "''${IPOD_DIR}/"
  '';
}
