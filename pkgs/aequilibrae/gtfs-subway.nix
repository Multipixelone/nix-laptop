{
  stdenv,
  fetchurl,
  unzip,
}:
stdenv.mkDerivation {
  pname = "gtfs-subway";
  version = "1.0";
  src = fetchurl {
    url = "http://web.mta.info/developers/data/nyct/subway/google_transit.zip";
    sha256 = "sha256-uK/1tjr3dkhadLfsxqV0N831doxDxNFHFPtculms2mU=";
  };
  sourceRoot = ".";
  nativeBuildInputs = [unzip];
  unpackCmd = ''${unzip}/bin/unzip "$src"'';
  installPhase = ''
    mkdir -p $out/new_york
    cp *.txt $out/new_york
  '';
}
