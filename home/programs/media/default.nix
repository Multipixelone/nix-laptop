{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ./mpv.nix
    ./spicetify.nix
  ];
  # TODO I don't like the way I wrote this directories module. Let's rethink this.
  directories.music-directory = "/media/Data/Music/";
  home.sessionVariables = {
    MUSIC_DIR = config.directories.music-directory;
  };
  home.packages = with pkgs; [
    ani-cli
    strawberry
    plexamp
    imv
    ffmpeg
    gifski
    mediainfo
    # FIX qt doesn't honor QT_QPA_PLATFORM if DISPLAY is set??
    (pkgs.symlinkJoin {
      name = "vlc";
      paths = [pkgs.vlc];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --unset DISPLAY
      '';
    })
    blanket
    nicotine-plus
    helvum
    (callPackage ../../../pkgs/foobar2000 {
      wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
      # location = "/media/TeraData/Games/cities-skylines-ii";
    })
  ];
  programs = {
    fish.shellAbbrs = {
      beet-import = "beet import /volume1/Media/ImportMusic/slskd/";
    };
    beets = {
      enable = true;
      settings = {
        directory = "/volume1/Media/Music";
        library = "/home/tunnel/.config/beets/library.db";
        plugins = "play the chroma fish replaygain lastgenre fetchart embedart lastimport edit discogs duplicates scrub missing";
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
          clutter = ["Thumbs.DB" ".DS_Store"];
        };
        convert = {
          auto = false;
          never_convert_lossy_files = true;
          command = "${pkgs.ffmpeg} -i $source -sample_fmt s16 -ar 44100 $dest";
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
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [
      mopidy-mpd
      mopidy-iris
      mopidy-mpris
      mopidy-scrobbler
      mopidy-local
      # (callPackage ../../../pkgs/mopidy/spotify.nix {})
    ];
    extraConfigFiles = [
      "${config.age.secrets."scrobblehome".path}"
      # "${config.age.secrets."spotify".path}"
    ];
    settings = {
      local = {
        media_dir = ["/media/Data/Music"];
        scan_timeout = 5000;
      };
      mpd = {
        hostname = "0.0.0.0";
      };
      http = {
        hostname = "0.0.0.0";
      };
      iris = {
        enabled = true;
        country = "US";
        locale = "en_US";
      };
      m3u = {
        enabled = true;
        playlists_dir = "/home/tunnel/.local/share/mopidy/m3u";
        base_dir = "";
      };
    };
  };
}
