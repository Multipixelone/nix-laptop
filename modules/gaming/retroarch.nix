{
  nixpkgs.config.allowUnfreePackages = [ "libretro-snes9x" ];
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    let
      retroarch-cores = pkgs.retroarch.withCores (
        cores: with cores; [
          gambatte
          gpsp
          melonds
          mupen64plus
          pcsx-rearmed
          pcsx2
          ppsspp
          snes9x
          bsnes
        ]
      );
    in
    {
      home.packages = [
        retroarch-cores
      ];
    };
}
