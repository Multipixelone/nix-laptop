{
  config,
  inputs,
  ...
}: {
  age.secrets."scribblepw".file = "${inputs.secrets}/media/lastfmpw.age";
  programs.rmpc = {
    enable = true;
    config = ''
      address: 127.0.0.1:6600
    '';
  };
  services = {
    mpd-mpris.enable = true;
    mpd = {
      enable = true;
      playlistDirectory = "${config.home.sessionVariables.PLAYLIST_DIR}/.mpd";
      musicDirectory = config.home.sessionVariables.MUSIC_DIR;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "PipeWire Output"
        }
      '';
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
