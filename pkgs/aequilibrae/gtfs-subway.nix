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
    sha256 = "sha256-msUFWRPSGI8XyU/pWvYKWWcfRLjw6TZsyHUbUs1i/GU=";
  };
  sourceRoot = ".";
  nativeBuildInputs = [unzip];
  unpackCmd = ''${unzip}/bin/unzip "$src"'';
  installPhase = ''
    mkdir -p $out/new_york
    cp *.txt $out/new_york
  '';
}
