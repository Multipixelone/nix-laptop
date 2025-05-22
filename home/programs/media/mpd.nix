{
  config,
  ...
}: {
  services = {
    mpd = {
      enable = true;
      playlistDirectory = config.home.sessionVariables.PLAYLIST_DIR;
      musicDirectory = config.home.sessionVariables.MUSIC_DIR;
    };
  };
}
