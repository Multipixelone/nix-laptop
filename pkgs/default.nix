{
  systems = [ "x86_64-linux" ];

  perSystem =
    { pkgs, ... }:
    {
      packages =
        let
          pins = import ../npins;
          args = { inherit pins; };
        in
        {
          pragmata = pkgs.callPackage ./pragmata { };
          moondeck = pkgs.qt6.callPackage ./moondeck args;
          slskd-stats = pkgs.python3Packages.callPackage ./slskd-stats args;
          # bandcamp-dl = pkgs.python3Packages.callPackage ./bandcamp-dl args;
          izotope = pkgs.callPackage ./izotope { };
          subway = pkgs.callPackage ./aequilibrae/gtfs-subway.nix { };
        };
    };
}
