{ pkgs, self, ... }:
{
  imports = [
    ./mpv.nix
    ./media-dl.nix
    ./spicetify.nix
    ./beets.nix
    # ./mopidy.nix
    ./ipod.nix
    ./mpd.nix
  ];
  home.packages = with pkgs; [
    ani-cli
    plexamp
    imv
    ffmpeg
    gifski
    mediainfo
    self.packages.${pkgs.stdenv.hostPlatform.system}.soundshow
    # FIX qt doesn't honor QT_QPA_PLATFORM if DISPLAY is set??
    (pkgs.symlinkJoin {
      name = "vlc";
      paths = [ pkgs.vlc ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vlc \
          --unset DISPLAY
      '';
    })
    blanket
    nicotine-plus
    helvum
    alsa-scarlett-gui
    scarlett2
    # (callPackage ../../../pkgs/foobar2000 {
    #   wine = inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-tkg;
    #   # location = "/media/TeraData/Games/cities-skylines-ii";
    # })
  ];
}
