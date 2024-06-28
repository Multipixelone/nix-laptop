{
  pkgs,
  config,
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
    vlc
    blanket
    pavucontrol
    nicotine-plus
    helvum
  ];
  services.mopidy = {
    enable = true;
    extensionPackages = with pkgs; [mopidy-mpd mopidy-iris mopidy-mpris mopidy-scrobbler mopidy-local (callPackage ../../../pkgs/mopidy/spotify.nix {})];
    extraConfigFiles = ["${config.age.secrets."scrobblehome".path}" "${config.age.secrets."spotify".path}"];
    settings = {
      local = {
        media_dir = [
          "/media/Data/Music"
        ];
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
