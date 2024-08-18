{
  lib,
  fetchurl,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "khinsider";
  version = "1.0.0";
  format = "other";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/obskyr/khinsider/master/khinsider.py";
    hash = "sha256-3CvK8ChqEXo4Cxjzhq0Rt3ILCrgrwMPsn2nnfT0RsDY=";
  };

  propagatedBuildInputs = [
    python3Packages.requests
    python3Packages.beautifulsoup4
  ];

  dontUnpack = true;
  doCheck = false;
  pytestCheckHook = false;

  installPhase = ''
    install -Dm755 ${src} $out/bin/${pname}
  '';

  meta = with lib; {
    homepage = "https://github.com/obskyr/khinsider";
    description = "Script to mass download albums from khinsider";
    maintainers = with maintainers; [Multipixelone];
  };
}
