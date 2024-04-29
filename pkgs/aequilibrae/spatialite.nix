{
  lib,
  fetchPypi,
  python3Packages,
  inputs,
}:
python3Packages.buildPythonApplication rec {
  pname = "spatialite";
  version = "0.0.3";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oHYfI5pS8yaxTOQbphtmFN/MgIuXigvsSjfB3prZBx4=";
  };
  doCheck = false;
  #configurePhase = ''
  #  rm -r openmatrix/test
  #'';
  pytestCheckHook = false;
  propagatedBuildInputs = [
    python3Packages.setuptools
    python3Packages.numpy
    python3Packages.tables
    inputs.geospatial.packages.x86_64-linux.libspatialite
  ];
  nativeBuildInputs = [
  ];
}
