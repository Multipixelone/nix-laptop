{
  lib,
  fetchFromGitHub,
  beets,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "beets-tcp";
  version = "1.0";
  pyproject = true;
  doCheck = false;
  pytestCheckHook = false;

  src = fetchFromGitHub {
    repo = "beets-tcp";
    owner = "trapd00r";
    rev = "9ef566ecca91a598c8b2d51084c0be2eb096c6e7";
    hash = "sha256-InyJQ6znD884UuXwUuQFsbNBIwTDuE1xGaNERj+KUig=";
  };

  nativeBuildInputs = [
    beets
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    titlecase
  ];

  postPatch = ''
    printf 'from pkgutil import extend_path\n__path__ = extend_path(__path__, __name__)\n' >__init__.py
  '';

  preBuild = ''
    mkdir beetsplug
    cp __init__.py tcp.py beetsplug/
        cat > setup.py << EOF
    from setuptools import setup

    setup(
      name='${pname}',
      version='${version}',

      packages=['beetsplug'],
      install_requires=['beets>=1.3.11'],
    )
    EOF
  '';
  meta = {
    description = "Beets plugin to manage external files";
    maintainers = with lib.maintainers; [
      Multipixelone
    ];
    license = lib.licenses.mit;
  };
}
