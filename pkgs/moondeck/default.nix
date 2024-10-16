{
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  qtbase,
  wrapQtAppsHook,
  qttools,
  qtconnectivity,
  qthttpserver,
  qtwebsockets,
  qtwayland,
  procps,
  libXrandr,
}:
stdenv.mkDerivation rec {
  pname = "moondeck-buddy";
  version = "1.6.2";

  src = fetchFromGitHub {
    repo = "moondeck-buddy";
    owner = "FrogTheFrog";
    rev = "v${version}";
    sha256 = "sha256-evFai6gdL8doIEGEpBUQDFlAWBwg2V3Yax2ELl2KBg0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ninja cmake pkg-config wrapQtAppsHook qtconnectivity qthttpserver procps libXrandr qtwebsockets];
  buildInputs = [qtbase qtwayland qttools qtconnectivity];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=Release"
    "-G Ninja"
  ];

  enableParallelBuilding = true;
}
