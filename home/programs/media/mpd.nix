{
  config,
  inputs,
  ...
}: {
  age.secrets."scribblepw".file = "${inputs.secrets}/media/lastfmpw.age";
  services = {
    mpd = {
      enable = true;
      playlistDirectory = config.home.sessionVariables.PLAYLIST_DIR;
      musicDirectory = config.home.sessionVariables.MUSIC_DIR;
    };
    mpdscribble = {
      enable = true;
      endpoints."last.fm" = {
        username = "Tunnelmaker";
        passwordFile = config.age.secrets."scribblepw".path;
      };
    };
  };
}
