{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication rec {
  pname = "bandcamp-dl";
  version = "0.0.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "iheanyi";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-PNyVEzwRMXE0AtTTg+JyWw6+FSuxobi3orXuxkG0kxw=";
  };

  propagatedBuildInputs = with python3Packages; [
    # requires beautifulsoup > 4.13
    (beautifulsoup4.overrideAttrs (old: {
      version = "4.13.4";
      src = pkgs.fetchPypi {
        version = "4.13.4";
        pname = "beautifulsoup4";
        hash = "sha256-27PE4c6uau/r2vJCMkcmDNBiQwpBDjjGbyuqUKhDcZU=";
      };
      patches = [];
      propagatedBuildInputs = old.propagatedBuildInputs ++ [typing-extensions];
    }))
    unicode-slugify
    mutagen
    requests
    demjson3
  ];

  build-system = [
    python3Packages.setuptools
  ];

  nativeBuildInputs = [
  ];

  doCheck = false;
  pytestCheckHook = false;

  meta = with lib; {
    homepage = "https://github.com/iheanyi/bandcamp-dl";
    description = "Simple python script to download Bandcamp albums";
    license = licenses.unlicense;
    maintainers = with maintainers; [Multipixelone];
  };
}
