{pkgs, ...}: {
  imports = [
  ];
  home.packages = with pkgs; [
    sysstat
    just
    i2c-tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    devenv
  ];
  home.sessionVariables = {
    MUSIC_DIR = "/media/Data/Music";
    MOPIDY_PLAYLISTS = "/home/tunnel/.local/share/mopidy/m3u";
    IPOD_DIR = "/run/media/tunnel/FINNR_S IPO";
    PLAYLIST_DIR = "/home/tunnel/Music/Playlists";
  };
}
