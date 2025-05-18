{pkgs, ...}: {
  imports = [
    ./mpv.nix
    ./spicetify.nix
    ./beets.nix
    ./mopidy.nix
  ];
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
    alsa-scarlett-gui
    scarlett2
    # (callPackage ../../../pkgs/foobar2000 {
    #   wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
    #   # location = "/media/TeraData/Games/cities-skylines-ii";
    # })
  ];
}
