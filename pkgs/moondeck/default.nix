{
  stdenv,
  cmake,
  ninja,
  wrapQtAppsHook,
  qt6,
  kdePackages,
  procps,
  xorg,
  steam,
  lib,
  pins,
}: let
  inherit (kdePackages) qtbase wrapQtAppsHook;
  qtEnv = with qt6;
    env "qt-env-custom-${qtbase.version}" [
      qthttpserver
      qtwebsockets
    ];
in
  stdenv.mkDerivation {
    pname = "moondeck-buddy";
    inherit (pins.moondeck-buddy) version;
    src = pins.moondeck-buddy;

    nativeBuildInputs = [
      ninja
      cmake
      wrapQtAppsHook
    ];

    buildInputs = [
      qtbase
      qtEnv
      xorg.libXrandr
      procps
      steam
    ];

    postPatch = ''
      substituteInPlace src/lib/shared/appmetadata.cpp \
          --replace-fail /usr/bin/steam ${lib.getExe steam};
    '';

    # cmakeFlags = [
    #   "-DCMAKE_BUILD_TYPE:STRING=Release"
    #   "-G Ninja"
    # ];

    meta = {
      mainProgram = "MoonDeckBuddy";
      description = "Helper to work with moonlight on a steamdeck";
      homepage = "https://github.com/FrogTheFrog/moondeck-buddy";
      license = lib.licenses.lgpl3Only;
      platforms = lib.platforms.linux;
    };
  }
