{
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  wrapQtAppsHook,
  qt6,
  procps,
  libXrandr,
  xcb-util-cursor,
  fuse,
  steam,
  lib,
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

  nativeBuildInputs = [
    ninja
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    qt6.qtwebsockets
    qt6.qthttpserver
    fuse
    xcb-util-cursor
    libXrandr
    procps
    steam
  ];

  postPatch = ''
    substituteInPlace src/lib/os/linux/steamregistryobserver.cpp \
        --replace-fail /usr/bin/steam ${lib.getExe steam};
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=Release"
    "-G Ninja"
  ];

  enableParallelBuilding = true;
}
