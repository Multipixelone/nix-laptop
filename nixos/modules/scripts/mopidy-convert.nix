{pkgs, ...}:
pkgs.writeShellApplication {
  name = "mopidy-convert";
  runtimeInputs = [pkgs.jq];

  text = ''
    #!/usr/bin/env bash

    # Function to URL-encode the filename
    urlencode() {
      local string="''${1}"
      local encoded=""

      encoded=$(printf %s "''${string}" | jq -sRr @uri | sed 's/%2F/\//g')
      echo "''${encoded}"
      REPLY="''${encoded}"
    }

    # Function to convert the filename to the desired format
    convert_filename() {
        local original_filename="$1"
        # Remove "/media/Data/Music/" prefix if present
        local trimmed_filename="''${original_filename#/media/Data/Music/}"
        # URL-encode the trimmed filename
        local encoded_filename
        encoded_filename=$(urlencode "$trimmed_filename")
        # Add "local:track:" prefix
        local final_filename="local:track:$encoded_filename"
        echo "$final_filename"
    }

    output_dir="$MOPIDY_PLAYLISTS"

    # Create the output directory if it doesn't exist
    mkdir -p "$output_dir"

    # Loop through all files in the current directory
    for file in *; do
      # Check if it's a regular file
      if [[ -f "$file" ]]; then
        # Convert the filename
        converted_filename="$file"
        # Create the output file path
        output_file="$output_dir/$converted_filename"
        # Write the converted filename to the output file, remove M3U header
        while IFS= read -r line; do
          # Process the line using convert_filename
          processed_line=$(convert_filename "$line")
          # Write the processed line to the output file
          echo "$processed_line" >> "$output_file" 
        done < <(tail -n +2 "$file")  # Read from the file, skipping the first line
      fi
    done
  '';
}
