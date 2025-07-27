{
  stdenv,
  lib,
  fetchsvn,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "mppenc";
  version = "495";

  src = fetchsvn {
    url = "http://svn.musepack.net/mppenc/trunk";
    rev = version;
    sha256 = "sha256-1rMnlmFs7dGdttN6QjmjBc7xH/4LzARlh9WGUIAhlHQ=";
  };

  # sourceRoot = "${pname}_r${version}";

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  postInstall = ''
    # install -d $out/include/replaygain
    # install -Dm644 include/replaygain/* -t $out/include/replaygain/
  '';

  meta = {
    mainProgram = "mppenc";
    description = "A library for calculating ReplayGain values (built from musepack r475 source)";
    homepage = "https://musepack.net";
    license = lib.licenses.lgpl2;
    platforms = lib.platforms.linux;
  };
}
