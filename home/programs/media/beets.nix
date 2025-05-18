{
  pkgs,
  lib,
  ...
}: let
  download-dir = "/volume1/Media/ImportMusic/slskd";
  music-dir = "/volume1/Media/Music";
  beets-dir = "/home/tunnel/.config/beets";
  beets-library = "${beets-dir}/library.db";
  beets-config = "${beets-dir}/config.yaml";
  detect-file = "${download-dir}/download-finished";
  script-packages = [
    pkgs.beets
    pkgs.coreutils
  ];
  beets-import = pkgs.writeShellApplication {
    name = "beets-import";
    runtimeInputs = script-packages;
    text = ''
      beet -c ${beets-config} import -q ${download-dir}
      rm -f ${detect-file}
    '';
  };
in {
  systemd.user = {
    paths.beets = {
      Unit.Description = "Watch download directory for new music";
      Path.PathChanged = detect-file;
      Install.WantedBy = ["multi-user.target"];
    };
    services.beets = {
      Unit.Description = "Automatically import and organize downloads using beets";
      Service = {
        Type = "oneshot";
        ReadOnlyPaths = [beets-config];
        ReadWritePaths = [
          download-dir
          music-dir
          beets-dir
        ];
        ExecStart = lib.getExe beets-import;
      };
    };
  };
  programs = {
    fish.shellAbbrs = {
      bi = "beet import";
    };
    beets = {
      enable = true;
      settings = {
        directory = music-dir;
        library = beets-library;
        plugins = "convert fromfilename play the chroma fish replaygain lastgenre fetchart embedart lastimport edit discogs duplicates scrub missing";
        lastfm.user = "Tunnelmaker";
        lastimport.user = "Tunnelmaker";
        ui.color = true;
        duplicates.checksum = false;
        scrub.auto = true;
        embedart.auto = true;
        chroma.auto = true;
        import = {
          move = true;
          write = true;
          resume = false;
          clutter = ["Thumbs.DB" ".DS_Store" "*.m3u" "*.sfv" "*.nfo" "*.jpg" "*.png"];
        };
        convert = {
          auto = false;
          never_convert_lossy_files = true;
          format = "mp3";
          formats = {
            mp3.command = "${lib.getExe pkgs.ffmpeg} -i $source -ab 320k -ac 2 -ar 44100 -joint_stereo 0 $dest";
            mp3.extension = "mp3";
            wav.command = "${lib.getExe pkgs.ffmpeg} -i $source -sample_fmt s16 -ar 44100 $dest";
          };
        };
        replaygain = {
          auto = true;
          overwrite = true;
          albumgain = true;
          backend = "gstreamer";
        };
        missing = {
          format = "$albumartist - $album - $track $title";
          count = true;
        };
        fetchart = {
          auto = true;
          cautious = false;
          cover_names = "cover front art album folder";
          maxwidth = 300;
          sources = "coverart albumart itunes amazon google";
        };
      };
    };
  };
}
