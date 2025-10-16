{
  stdenv,
  lib,
  fetchsvn,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "libreplaygain";
  version = "495";

  # src = fetchzip {
  #   url = "https://files.musepack.net/source/${pname}_r${version}.tar.gz";
  #   sha256 = "sha256-KVOwtVtEBsdPMTWsjRCbL0qo3tOJoERWgPLVHRA2ddg=";
  # };

  src = fetchsvn {
    url = "http://svn.musepack.net/${pname}";
    rev = version;
    sha256 = "sha256-5yhP/2kMZN7rziXvAtvJ1xCr1A9R4zOwzX2R0zYdt+g=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
  ];

  postInstall = ''
    install -d $out/include/replaygain
    install -m644 "${src}/include/replaygain/gain_analysis.h" "$out/include/replaygain/"
    # install -Dm644 include/replaygain/* -t $out/include/replaygain/
  '';

  meta = {
    description = "A library for calculating ReplayGain values (built from musepack r475 source)";
    homepage = "https://musepack.net";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
  };
}
