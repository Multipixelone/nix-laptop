{ inputs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [ "soundshow" ];
  flake.modules.homeManager.gui =
    { pkgs, ... }:
    let
      nixpkgs-mine = import inputs.nixpkgs-mine {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    in
    {
      home.packages = with pkgs; [
        ani-cli
        imv
        ffmpeg
        gifski
        mediainfo
        nixpkgs-mine.soundshow
        blanket
        helvum
      ];
    };
}
