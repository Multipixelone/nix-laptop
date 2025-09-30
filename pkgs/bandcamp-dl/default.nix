{
  lib,
  python3Packages,
  buildPythonApplication,
  pins,
  unicode-slugify,
  beautifulsoup4,
  mutagen,
  requests,
  demjson3,
  # fetchPypi,
  # typing-extensions,
  setuptools,
}:
buildPythonApplication {
  pname = "bandcamp-dl";
  inherit (pins.bandcamp-dl) version;
  src = pins.bandcamp-dl;
  pyproject = true;

  propagatedBuildInputs = [
    # requires beautifulsoup > 4.13
    # (beautifulsoup4.overrideAttrs (old: {
    #   version = "4.13.4";
    #   src = fetchPypi {
    #     version = "4.13.4";
    #     pname = "beautifulsoup4";
    #     hash = "sha256-27PE4c6uau/r2vJCMkcmDNBiQwpBDjjGbyuqUKhDcZU=";
    #   };
    #   patches = [];
    #   propagatedBuildInputs = old.propagatedBuildInputs ++ [typing-extensions];
    # }))
    beautifulsoup4
    unicode-slugify
    mutagen
    requests
    demjson3
  ];

  build-system = [
    setuptools
  ];

  nativeBuildInputs = [
  ];

  doCheck = false;
  pytestCheckHook = false;

  meta = with lib; {
    homepage = "https://github.com/iheanyi/bandcamp-dl";
    description = "Simple python script to download Bandcamp albums";
    license = licenses.unlicense;
    maintainers = with maintainers; [ Multipixelone ];
  };
}
