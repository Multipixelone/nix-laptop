{
  pkgs,
  inputs,
  ...
}:
{
  services.playerctld.enable = true;
  environment.systemPackages = [
    inputs.khinsider.packages.${pkgs.stdenv.hostPlatform.system}.default
    # self.packages.${pkgs.stdenv.hostPlatform.system}.bandcamp-dl

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
