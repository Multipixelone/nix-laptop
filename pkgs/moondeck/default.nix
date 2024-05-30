{
  stdenv,
  lib,
  fetchFromGitHub,
  which,
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
  xrandr,
  libXrandr,
}:
stdenv.mkDerivation rec {
  pname = "moondeck-buddy";
  version = "1.6.1";

  src = fetchFromGitHub {
    repo = "moondeck-buddy";
    owner = "FrogTheFrog";
    rev = "v${version}";
    sha256 = "sha256-1YprssMx97svStKM+6WWLWKt+/CRxf//uC8oRZO//Cs=";
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
