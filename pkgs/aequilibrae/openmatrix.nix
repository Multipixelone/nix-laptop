{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "aequilibrae";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "osPlanning";
    repo = "omx-python";
    rev = "337ea4deff0c0055a6e792a5bf45aabf3fc82075";
    hash = "sha256-8gFq6gnTP2cZ/Vjm9jZ/C+ew8Ry0iR7gC9HVqnvTpFI=";
  };

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.numpy
    python3Packages.tables
  ];

  nativeBuildInputs = [
    python3Packages.pytestCheckHook
    python3Packages.nose
  ];

}
