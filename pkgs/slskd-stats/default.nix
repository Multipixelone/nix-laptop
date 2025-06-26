{
  buildPythonApplication,
  pins,
}:
buildPythonApplication {
  pname = "slskd-stats";
  inherit (pins.slskd-stats) version;
  src = pins.slskd-stats;
  pyproject = false;

  installPhase = ''
    install -Dm755 main.py $out/bin/slskd-stats
  '';

  meta.mainProgram = "slskd-stats";
}
