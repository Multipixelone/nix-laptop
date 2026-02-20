{
  nixpkgs.config.allowUnfreePackages = [ "plexamp" ];
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        plexamp
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
      ];
    };
}
