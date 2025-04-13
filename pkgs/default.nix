{
  systems = ["x86_64-linux"];

  perSystem = {pkgs, ...}: {
    packages = {
      pragmata = pkgs.callPackage ./pragmata {};
      moondeck = pkgs.qt6.callPackage ./moondeck {};
      spotify2musicbrainz = pkgs.callPackage ./spotify2musicbrainz {};
      izotope = pkgs.callPackage ./izotope {};
      subway = pkgs.callPackage ./aequilibrae/gtfs-subway.nix {};
      apple-emoji = pkgs.callPackage ./apple-fonts {};
    };
  };
}
