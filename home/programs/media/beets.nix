{
  config,
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
  ffmpeg = lib.getExe pkgs.ffmpeg-headless;
  beets-filetote = pkgs.beets.override {
    pluginOverrides = {
      filetote = {
        enable = true;
        propagatedBuildInputs = [pkgs.beetsPackages.filetote];
      };
    };
  };
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
      Install.WantedBy = ["default.target"];
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
  # thanks 5225225 (https://github.com/5225225/dotfiles/blob/bf95910ad4b7929ddce1865162f3c16064e74d8e/user/beets/beets.nix#L138)
  xdg.configFile."fish/completions/beet.fish".source =
    pkgs.runCommand "beets-completion" {
      config = (pkgs.formats.yaml {}).generate "beets-config" config.programs.beets.settings;
    }
    ''
      export BEETSDIR="/tmp"

      ${lib.getExe config.programs.beets.package} -l /tmp/db -c "$config" fish --output "$out"
    '';
  programs = {
    fish.shellAbbrs = {
      bi = "beet import";
    };
    beets = {
      enable = true;
      package = beets-filetote;
      settings = {
        directory = music-dir;
        library = beets-library;
        plugins = [
          "badfiles"
          "chroma"
          "convert"
          "duplicates"
          "edit"
          "embedart"
          "fetchart"
          "filetote"
          "fish"
          "fromfilename"
          "lastgenre"
          "lastimport"
          "mbsubmit"
          "mbsync"
          "missing"
          "play"
          "replaygain"
          "scrub"
          "the"
        ];
        clutter = [
          "Thumbs.DB"
          ".DS_Store"
          "*.m3u"
          "*.cue"
          "*.lrc"
          "*.sfv"
          "*.txt"
          "*.log"
          "*.nfo"
          "*.jpg"
          "*.jpeg"
          "*.png"
        ];
        lastfm.user = "Tunnelmaker";
        lastimport.user = "Tunnelmaker";
        mbsubmit.picard_path = lib.getExe pkgs.picard;
        ui.color = true;
        duplicates.checksum = false;
        scrub.auto = true;
        embedart.auto = true;
        chroma.auto = true;
        import = {
          move = true;
          write = true;
          resume = false;
          log = "${download-dir}/import.log";
        };
        match = {
          strong_rec_thresh = 0.1;
          max_rec.missing_tracks = "low";
          preferred = {
            countries = [
              "XW"
              "US"
            ];
            media = [
              "Digital Media|File"
              "CD"
            ];
            original_year = true;
          };
          # don't show me anything with missing tracks
          ignored = "missing_tracks unmatched_tracks";
        };
        convert = {
          auto = false;
          never_convert_lossy_files = true;
          format = "mp3";
          formats = {
            mp3.command = "${ffmpeg} -i $source -ab 320k -ac 2 -ar 44100 -joint_stereo 0 $dest";
            mp3.extension = "mp3";
            wav.command = "${ffmpeg} -i $source -sample_fmt s16 -ar 44100 $dest";
          };
        };
        replaygain = {
          auto = true;
          overwrite = true;
          albumgain = true;
          backend = "ffmpeg";
          command = ffmpeg;
          threads = 6;
        };
        missing = {
          format = "$albumartist - $album - $track $title";
          count = true;
        };
        badfiles = {
          check_on_import = true;
          # TODO: add command that checks bitrate of opus files and errors when <200
          commands = {
            flac = "${lib.getExe pkgs.flac} --test --warnings-as-errors --silent";
          };
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
