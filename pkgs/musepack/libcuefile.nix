{
  stdenv,
  lib,
  fetchzip,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "libcuefile";
  version = "475";

  src = fetchzip {
    url = "https://files.musepack.net/source/${pname}_r${version}.tar.gz";
    sha256 = "sha256-okNAwyJ/pXJZvMQeuvNzNDR9xgMzItFQx1BP/xhlYto=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  # installPhase = ''
  # runHook preInstall

  # install -d $out/lib/
  # install -Dm644 ${sourceRoot}include/cuetools/* -t $out/include/cuetools

  # runHook postInstall
  # '';

  preInstall = ''
    # install -d $out/include/cuetools
    mkdir -p $out/include/cuetools
    # install -m644 "libcuefile_r475/include/cuetools/*" "$out/include/cuetools/"
    install -m644 "${src}/include/cuetools/cuefile.h" "$out/include/cuetools/"
    install -m644 "${src}/include/cuetools/cd.h" "$out/include/cuetools/"
    install -m644 "${src}/include/cuetools/cdtext.h" "$out/include/cuetools/"
  '';

  preFixup = ''
    install -m644 $out/lib/libcuefile.so $out/lib/libcue.so
  '';

  NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  meta = {
    description = "A library for calculating ReplayGain values (built from musepack r475 source)";
    homepage = "https://musepack.net";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
  };
}
