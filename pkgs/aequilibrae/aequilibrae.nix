{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "aequilibrae";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "AequilibraE";
    repo = "aequilibrae";
    rev = "77edeae154a42dedb764ae4b2e1f32accdd3676c";
    hash = "sha256-UJCGeFUBRdkhi/UQFYBgyRerF/0kW5X++SU3h8hVnrM=";
  };
  format = "pyproject";

  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.responses
    python3Packages.numpy
    python3Packages.scipy
    python3Packages.pyaml
    python3Packages.cython
    python3Packages.requests
    python3Packages.shapely
    python3Packages.pandas
    python3Packages.pyproj
    python3Packages.rtree
    python3Packages.openmatrix
    python3Packages.geopandas  
  ];

  nativeBuildInputs = [
    python3Packages.pytestCheckHook
  ];

}
