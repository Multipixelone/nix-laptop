{
  config,
  self,
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
  ffmpeg = lib.getExe pkgs.ffmpeg-headless;
  beets-filetote = pkgs.beets.override {
    pluginOverrides = {
      tcp = {
        enable = true;
        propagatedBuildInputs = [self.packages.${pkgs.system}.beets-tcp];
      };
      filetote = {
        enable = true;
        propagatedBuildInputs = [pkgs.beetsPackages.filetote];
      };
    };
  };
  beets-import = pkgs.writeShellApplication {
    name = "beets-import";
    runtimeInputs = [beets-filetote pkgs.coreutils];
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
      mpdIntegration.enableUpdate = true;
      settings = {
        directory = music-dir;
        library = beets-library;
        plugins = [
          # "albumtypes"
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
          "hook"
          "info"
          "inline"
          "lastgenre"
          "lastimport"
          "mbsubmit"
          "mbsync"
          "missing"
          "play"
          "replaygain"
          "scrub"
          "tcp"
          "the"
        ];
        clutter = [
          "Thumbs.DB"
          ".DS_Store"
          "*.m3u"
          "*.lrc"
          "*.sfv"
          "*.txt"
          "*.nfo"
          "*.xml"
          "*.docx"
          "*.jpg"
          "*.jpeg"
          "*.png"
        ];
        # get rid of reserved characters instead of replacing with underscore
        replace = {
          "[\\\\/]" = "";
          "[\/]" = "";
          "^\\." = "";
          "[\\x00-\\x1f]" = "";
          "[<>:\"\\?\\*\\|]" = "";
          "\\.$" = "";
          "\\s+$" = "";
          "^\\s+" = "";
          "^-" = "";
        };
        per_disc_numbering = true;
        lastfm.user = "Tunnelmaker";
        lastimport.user = "Tunnelmaker";
        mbsubmit.picard_path = lib.getExe pkgs.picard;
        ui.color = true;
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
        duplicates = {
          checksum = false;
          tiebreak = {
            items = ["bitrate"];
          };
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
        # albumtypes.types = [
        #   "ep: 'EP'"
        # ];
        hook.hooks = [
          {
            event = "album_imported";
            command = ''${lib.getExe' pkgs.coreutils "printf"} "\033[38;5;76m √\033[m \033[1m\033[m \033[38;5;30m{album}\033[m\n"'';
          }
          {
            event = "before_choose_candidate";
            command = ''${lib.getExe pkgs.hr} ━'';
          }
        ];
        filetote = {
          # keep relevant files with album
          extensions = [
            ".cue"
            ".log"
            ".accurip"
          ];
          # move lyric files with music
          pairing = {
            enabled = true;
            pairing_only = true;
            extensions = [".lrc"];
          };
          paths = {
            "ext:.log" = "$albumpath/$artist - $album";
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
          commands = let
            opus-test = pkgs.writeShellApplication {
              name = "opus-test";
              runtimeInputs = [
                pkgs.mediainfo
                pkgs.jq
              ];
              text = ''
                REQUIRED_BITRATE_KBPS=200
                BITRATE_BPS=$((REQUIRED_BITRATE_KBPS * 1000))
                overall_bitrate=$(mediainfo --Output=JSON "''${1}" \
                | jq -er '.media.track[] | select(.["@type"] == "General") | .OverallBitRate')

                current_bitrate_bps_int=$((overall_bitrate))
                current_bitrate_kbps=$((current_bitrate_bps_int / 1000))

                if [ "$current_bitrate_bps_int" -lt "$BITRATE_BPS" ]; then
                  echo "Error: bitrate ''${current_bitrate_kbps} is less then required"
                  exit 4
                else
                  echo "Bitrate exceeds the requirement"
                  exit 0
                fi
              '';
            };
          in {
            flac = "${lib.getExe pkgs.flac} --test --warnings-as-errors --silent";
            opus = lib.getExe opus-test;
          };
        };
        tcp.asis = [
          "EP"
          "LP"
          "feat. "
          "PhD"
          "DJ"
          "TCP"
          "SOS"
          "DMC"
          "A$AP"
          "OST"
          "PAL"
          "NTSC"
          "T.I"
          "II"
          "III"
          "IV"
          "VI"
          "VII"
          "VIII"
          "IX"
          "XI"
          "XII"
          "XIII"
          "XIV"
          "XV"
          "XVI"
          "XVII"
          "XVIII"
          "XIX"
          "XX"
        ];
        # these album and item fields lovingly borrowed from http://github.com/trapd00r/configs
        album_fields = {
          alb_type = ''
            alb_types = ""
            albumtypes_list = {
              'ep': 'EP',
              'lp': 'LP',
              'single': 'Single',
              'live': 'Live',
              'remix': 'Remix',
              'dj-mix': 'DJ-mix',
              'mixtape/street': 'Mixtape',
              'interview': 'Interview',
            }
            for key, value in albumtypes_list.items():
              if albumtype == key:
                alb_types += str(value)

              if alb_types is not None:
                if alb_types != ''':
                  return alb_types + ', '
              else:
                return None
          '';
          media_type = ''
            media_list = {
             '12" Vinyl':     'Vinyl',
             '10" Vinyl':     'Vinyl',
             '7" Vinyl':      'Vinyl',
             'Vinyl':         'Vinyl',
             'CDr':           'CDR',
             'CD-R':          'CDR',
             'Cassette':      'Cassette',
             'Digital Media': 'Web',
             'CD':            'CD',
             'File':          'Web',
             'DVD':           'DVDA',
            }
            media_types_to_omit = ['Blu-spec CD']
            if items[0].media in media_list:
              return str(media_list[items[0].media]) + ', '
            elif items[0].media in media_types_to_omit:
              return None
            elif items[0].media == ''':
              return None
            else:
              return str(items[0].media) + ', '
          '';
        };
        item_fields = {
          multidisc = "1 if disctotal > 1 else 0";
          first_artist = ''
            # import an album to another artists directory, like:
            # Tom Jones │1999│ Burning Down the House [Single, CD, FLAC]
            # to The Cardigans/+singles/Tom Jones & the Cardigans │1999│ Burning Down the House [Single, CD, FLAC]
            # https://github.com/beetbox/beets/discussions/4012#discussioncomment-1021414
            # beet import --set myartist='The Cardigans'
            # we must first check to see if myartist is defined, that is, given on
            # import time, or we raise an NameError exception.
            try:
              myartist
            except NameError:
              import re
              return re.split(r',|\s+(feat(.?|uring)|&|(Vs|Ft).)', albumartist, 1, flags=re.IGNORECASE)[0]
            else:
              return myartist
          '';

          first_artist_singleton = ''
            try:
              myartist
            except NameError:
              import re
              return re.split(r',|\s+(feat(.?|uring)|&|(Vs|Ft).)', artist, 1, flags=re.IGNORECASE)[0]
            else:
              return myartist
          '';
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
