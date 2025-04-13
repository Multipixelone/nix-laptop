{
  lib,
  stdenv,
  fetchurl,
  p7zip,
}:
stdenv.mkDerivation rec {
  pname = "apple-emoji";
  version = "1.2";

  emoji = fetchurl {
    url = "https://github.com/samuelngs/apple-emoji-linux/releases/download/v17.4/AppleColorEmoji.ttf";
    sha256 = "sha256-SG3JQLybhY/fMX+XqmB/BKhQSBB0N1VRqa+H6laVUPE=";
  };

  nativeBuildInputs = [p7zip];

  sourceRoot = ".";

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp ${emoji} $out/share/fonts/truetype
  '';

  meta = {
    description = "Apple color emoji fonts";
    homepage = "https://developer.apple.com/fonts/";
    license = lib.licenses.unfree;
  };
}
