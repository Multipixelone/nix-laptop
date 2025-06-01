{
  config,
  inputs,
  pkgs,
  lib,
  ...
}: let
  media-drive = "/volume1/Media";
  download-dir = "${media-drive}/ImportMusic/slskd";
  music-dir = "${media-drive}/Music";
  transcoded-music = "${media-drive}/TranscodedMusic";
  beets-dir = "/home/tunnel/.config/beets";
  beets-library = "${beets-dir}/library.db";
  beets-config = "${beets-dir}/config.yaml";
  detect-file = "${download-dir}/download-finished";
  ffmpeg = lib.getExe pkgs.ffmpeg-headless;
  # use my custom build of beets with included plugins
  beets-plugins = inputs.beets-plugins.packages.${pkgs.system}.default;
  beets-import = pkgs.writeShellApplication {
    name = "beets-import";
    runtimeInputs = [beets-plugins pkgs.coreutils];
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
  age.secrets."beets-plex".file = "${inputs.secrets}/media/plexbeets.age";
  programs = {
    fish.shellAbbrs = {
      bi = "beet import";
    };
    beets = {
      enable = true;
      package = beets-plugins;
      mpdIntegration.enableUpdate = true;
      settings = {
        directory = music-dir;
        library = beets-library;
        include = [config.age.secrets.beets-plex.path];
        plugins = [
          # "albumtypes"
          "alternatives"
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
          "plexsync"
          "replaygain"
          "scrub"
          "smartplaylist"
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
          log = "${beets-dir}/logs/import.log";
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
            # we match based on the best fit and then include the $original_year in the file path
            original_year = false;
          };
          # don't show me anything with missing tracks
          # this makes beets not show what tracks an album is missing. ever. LOL
          # ignored = "missing_tracks unmatched_tracks";
        };
        duplicates = {
          checksum = false;
          tiebreak = {
            items = ["bitrate"];
          };
        };
        alternatives.ipod = {
          directory = transcoded-music;
          formats = "opus mp3 m4a";
          query = "onipod:true";
        };
        convert = {
          auto = false;
          never_convert_lossy_files = true;
          format = "mp3";
          formats = {
            mp3.command = "${ffmpeg} -i $source -ab 320k -ac 2 -ar 44100 -joint_stereo 0 $dest";
            mp3.extension = "mp3";
            wav.command = "${ffmpeg} -i $source -sample_fmt s16 -ar 44100 $dest";
            # 128K is probably overkill LOL but I want something *close* to transparent on my ipod
            opus.command = "${ffmpeg} -i $source -c:a libopus -b:a 128K $dest";
          };
        };
        # albumtypes.types = [
        #   "ep: 'EP'"
        # ];
        hook.hooks = let
          log-timestamp = pkgs.writeShellApplication {
            name = "log-timestamp";
            runtimeInputs = with pkgs; [
              dateutils
            ];
            text = ''
              export LOGDIR="${beets-dir}/logs"
              export LOG="''${LOGDIR}/import_times.log"
              DATE=$(date "+%Y/%m/%d at %H:%M:%S")
              SECONDS=$(date +%s)

              if tail -1 ''${LOG} | grep 'Import end' > /dev/null
              then
                # shellcheck disable=SC2059
                printf "''${SECONDS} on ''${DATE} $*\n" >> ''${LOG}
              else
                if tail -1 ''${LOG} | grep '^# Import' > /dev/null
                then
                  # shellcheck disable=SC2059
                  printf "''${SECONDS} on ''${DATE} $*\n" >> ''${LOG}
                else
                  PREVSECS=$(tail -1 ''${LOG} | awk ' { print $1 } ')
                  if [ "''${PREVSECS}" ]
                  then
                    ELAPSECS=$(( SECONDS - PREVSECS ))
                    # shellcheck disable=SC2016
                    ELAPSED=$(eval "echo elapsed time: $(date -ud "@$ELAPSECS" +'$((%s/3600/24)) days %H hr %M min %S sec')")
                    # shellcheck disable=SC2059
                    printf "''${SECONDS} on ''${DATE} $* , ''${ELAPSED}\n" >> ''${LOG}
                  else
                    # shellcheck disable=SC2059
                    printf "''${SECONDS} on ''${DATE} $*\n" >> ''${LOG}
                  fi
                fi
              fi
            '';
          };
        in [
          {
            event = "album_imported";
            command = ''${lib.getExe' pkgs.coreutils "printf"} "\033[38;5;76m √\033[m \033[1m\033[m \033[38;5;30m{album.path}\033[m\n"'';
          }
          {
            event = "before_choose_candidate";
            command = ''${lib.getExe pkgs.hr} ━'';
          }
          {
            event = "import_begin";
            command = "${lib.getExe log-timestamp} Import begin";
          }
          {
            event = "import";
            command = "${lib.getExe log-timestamp} Import end";
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
        plexsync = {
          use_llm_search = true;
          playlists = {
            defaults.maxtracks = 20;
            items = [
              {
                id = "daily_discovery";
                name = "80 daily discovery";
              }
              {
                id = "forgotten_gems";
                name = "90 forgotten gems";
              }
            ];
          };
        };
        llm = {
          search = {
            provider = "ollama";
            model = "deepseek-r1:7b-qwen-distill-q4_K_M";
            ollama_host = "http://localhost:11434";
          };
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
        smartplaylist = {
          relative_to = config.programs.beets.settings.directory;
          playlist_dir = config.home.sessionVariables.PLAYLIST_DIR;

          playlists = [
            {
              name = "monthly_beets";
              query = "plex_lastratedat:-2w.. plex_userrating:10";
            }
          ];
        };
        # these album and item fields lovingly borrowed from http://github.com/trapd00r/configs
        album_fields = {
          disambig = ''
            o = []
            if year > original_year:
              o.append(f"RE-{year}")
            if albumdisambig:
              o.append(albumdisambig)

            return ", ".join(o)
          '';
          # mp3_bitrate_setting = ''
          #   o = [f for f in brm] if brm else []

          #   return ", ".join(o)
          # '';
          # mp3_encoder = ''
          #   brm = set([i.encoder_settings for i in items])
          #   o = [f for f in brm] if brm else []

          #   return ", ".join(o)
          # '';
          source = ''
            format = set([i.format for i in items])
            tbr = sum([i.bitrate for i in items])
            abr = tbr / len(items) / 1000
            # brm = set([i.bitrate_mode for i in items])
            samplerate = set([i.samplerate for i in items])
            bitdepth = sum([i.bitdepth for i in items]) // len(items)

            # Init output
            o = [f for f in format] if format else []

            # Handle bitrate categories
            for f in format:
                if f == 'FLAC':
                  for p in samplerate:
                      o.append(str(p // 1000) + '-' + str(bitdepth))
                # if f == 'MP3' and brm:
                #   for p in brm:
                #       o.append(p)

            if abr < 480 and abr >= 320:
                o.append('320')
            elif abr < 320 and abr >= 220:
                o.append('V0')
            elif abr < 215 and abr >= 170 and abr != 192:
                o.append('V2')
            elif abr == 192:
                o.append('192')
            elif abr < 170:
                o.append(str(abr))

            return ", ".join(o)
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
          is_single = "1 if disctotal == 1 and tracktotal == 1 else 0";
          # fallback first artist if no albumartists_sort field
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
        aunique = {
          keys = "albumartist
            albumtype
            year
            album";
          disambiguators = "format
            mastering
            media
            label
            albumdisambig
            releasegroupdisambig";
        };
        ui.colors = {
          # main UI colors
          text_success = "green";
          text_warning = "blue";
          text_error = "red";
          text_highlight = "blue";
          text_highlight_minor = "lightgray";
          action_default = "darkblue";
          action = "purple";
        };

        paths = let
          # this lovely snippet pulls the first artist from the albumartists_sort field :-)
          first_artist = "%tcp{%ifdef{albumartists_sort,%first{$albumartists_sort,1,0,\␀},$first_artist}}";
          # if no month and day just display year, otherwise display all three
          date = "%if{$original_year,($original_year%if{$original_month,.$original_month.$original_day}) ,) }";
          # ex. 01-01. Tyler, the Creator ft. Frank Ocean - Slater.wav
          track_path = "%if{$multidisc,$disc-}%if{$track,$track}. $artist - $title";
          # show my custom field if there is a re-release or tagged disambiguation
          disambig_rerelease = "%if{$disambig,($disambig) }";
        in {
          "albumtype:soundtrack, genre:Soundtrack" = "OST/$album ${disambig_rerelease}${date}[$media_type$source]/${track_path}";
          default = "${first_artist}/$albumartist ${date}%if{$albumtype,($albumtype) }$album ${disambig_rerelease}[$media_type$source]/${track_path}";
          singleton = "$albumartist/Singles/$title";
          comp = "Various Artists/$album ${disambig_rerelease}${date}[$media_type$source]/${track_path}";
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
