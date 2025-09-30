{
  lib,
  fetchFromGitHub,
  python3Packages,
  mopidy,
  unstableGitUpdater,
}:
python3Packages.buildPythonApplication rec {
  pname = "mopidy-spotify";
  version = "unstable-2024-04-27";

  src = fetchFromGitHub {
    owner = "mopidy";
    repo = "mopidy-spotify";
    rev = "e8de77ebd2ca7dcd22682c929588f1b5225dda74";
    hash = "sha256-QeABG9rQKJ8sIoK38R74N0s5rRG+zws7AZR0xPysdcY=";
  };

  propagatedBuildInputs = [
    mopidy
    python3Packages.responses
  ];

  nativeBuildInputs = [
    python3Packages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_spotify" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-spotify";
    description = "Mopidy extension for playing music from Spotify";
    license = licenses.asl20;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
