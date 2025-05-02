{
  lib,
  fetchurl,
  python3Packages,
}:
python3Packages.buildPythonApplication {
  pname = "spotify2musicbrainz";
  version = "0.3.2";

  src = fetchurl {
    url = "https://gitlab.com/Freso/spotify2musicbrainz/-/archive/0.3.2/spotify2musicbrainz-0.3.2.tar.gz";
    hash = "sha256-OLDb/NleqB6cLaD+jKagn/aCROW+SSuxkXASZ91Ao64=";
  };

  propagatedBuildInputs = [
    python3Packages.musicbrainzngs
    python3Packages.spotipy
    python3Packages.setuptools-scm
  ];

  nativeBuildInputs = [
  ];

  doCheck = false;
  pytestCheckHook = false;

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-spotify";
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = with maintainers; [lilyinstarlight];
  };
}
