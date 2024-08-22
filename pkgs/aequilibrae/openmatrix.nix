{
  fetchPypi,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "OpenMatrix";
  version = "0.3.5.0";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HBAVW75l609ULDiIE9ja2PMX3+ZC+09hYnbJXmZUve4=";
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
  ];
  nativeBuildInputs = [
  ];
}
