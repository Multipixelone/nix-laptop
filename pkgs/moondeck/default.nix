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
  version = "0.11";

  src = fetchFromGitHub {
    repo = "moondeck-buddy";
    owner = "FrogTheFrog";
    rev = "43e599a423eaac7c1875b5ee956787acb78afff5";
    sha256 = "sha256-I7S6ZGrK8/mf1e2YwcYmxrDs5ZWA/d3tOFxtJQ0a3hs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ninja cmake pkg-config wrapQtAppsHook qtconnectivity qthttpserver procps libXrandr qtwebsockets];
  buildInputs = [qtbase qtwayland qttools qtconnectivity];
  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=Release"
  ];

  enableParallelBuilding = true;
}
