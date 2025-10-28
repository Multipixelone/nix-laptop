{
  lib,
  stdenv,
  meson,
  ninja,
  fftw,
  pkg-config,
  fetchFromGitHub,
}:
stdenv.mkDerivation rec {
  pname = "lossywav";
  version = "5c04ba376d87e9887b041e976cc32596a5c65f59";

  buildInputs = [
    fftw
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  src = fetchFromGitHub {
    owner = "xiota";
    repo = "lossywav-for-posix";
    rev = version;
    sha256 = "sha256-VU77YCyODvEGymfsDN43pzNRnSxpF9tn+aWHkb6JAUM=";
  };

  meta = {
    mainProgram = "lossywav";
    description = "lossy encoder for WAV files";
    homepage = "https://github.com/xiota/lossywav-for-posix";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
