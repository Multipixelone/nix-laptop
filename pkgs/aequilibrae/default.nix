{
  lib,
  fetchPypi,
  python3Packages,
  callPackage,
  sqlite,
  inputs,
}:
python3Packages.buildPythonApplication rec {
  pname = "aequilibrae";
  version = "1.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wpqA7/PLcfwrLm4JN0LkA85Jp59W22S90LvOJ9EXbEU=";
  };
  format = "pyproject";
  doCheck = false;

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
    python3Packages.geopandas
    python3Packages.pyarrow
    python3Packages.pyqt5
    (callPackage ./openmatrix.nix {})
    (callPackage ./spatialite.nix {inherit inputs;})
    inputs.geospatial.packages.x86_64-linux.libspatialite
    sqlite
  ];

  nativeBuildInputs = [
  ];
}
