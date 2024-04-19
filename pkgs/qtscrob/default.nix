{
  stdenv,
  lib,
  fetchFromGitHub,
  which,
  qttools,
  wrapQtAppsHook,
  qmake,
  qt5,
}:
stdenv.mkDerivation rec {
  pname = "qtscrobbler";
  version = "0.11";

  src = fetchFromGitHub {
    repo = "QtScrobbler";
    owner = "marcelpetrick";
    rev = "279bc3035ce4e8575b90f4d37616f74d7bfab5ee";
    sha256 = "sha256-eF1xzZTmLxgN/qKxAFtMy0Lsl7WrZzBxgHSIjfy1pJk=";
  };

  nativeBuildInputs = [qmake wrapQtAppsHook qttools which which];
  buildInputs = [
    qt5.full
  ];

  enableParallelBuilding = true;
  patch = [./disable_man.patch];

  postPatch = ''
    cd src
    sed -i -e "s,/usr/local,$out," -e "s,/usr,," common.pri
  '';

  meta = with lib; {
    description = "Qt based last.fm scrobbler";
    longDescription = ''
      QTScrobbler is a tool to upload information about the tracks you have played from your Digital Audio Player (DAP) to your last.fm account.
      It is able to gather this information from Apple iPods or DAPs running the Rockbox replacement firmware.
    '';

    homepage = "http://qtscrob.sourceforge.net";
    license = licenses.gpl2;
    maintainers = [maintainers.vanzef];
    platforms = platforms.linux;
  };
}
