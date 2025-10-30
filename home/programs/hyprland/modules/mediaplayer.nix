{
  lib,
  pkgs,
  gtk3,
  python3,
  glib,
  gobject-introspection,
  fetchFromGitHub,
  wrapGAppsHook3,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "mediaplayer";
  version = "1.0";
  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "Waybar";
    rev = "ddc767cd815a7c429bc4dd7f185fad93e485271d";
    sha256 = "sha256-dQW43ZxDrBvMCefvTCjaV3hEpYCU6KTJl/JxR8XZhwM=";
  };
  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    pkgs.playerctl
  ];
  buildInputs = [
    gtk3
    glib
    pkgs.playerctl
  ];
  propagatedBuildInputs = [
    pkgs.playerctl
    (pkgs.python3.withPackages (p: [
      p.pygobject3
    ]))
  ];
  preBuild = ''
        cat > setup.py << EOF
    from setuptools import setup

    setup(
      name='mediaplayer',
      version='1.0',
      scripts=[
        'resources/custom_modules/mediaplayer.py',
      ],
      entry_points={
        # example: file some_module.py -> function main
        #'console_scripts': ['someprogram=some_module:main']
      },
    )
    EOF
  '';
  strictDeps = false;
  installPhase = "install -Dm755 resources/custom_modules/mediaplayer.py $out/bin/mediaplayer.py";
  preFixup = ''
    makeWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        # Hard requirements
        pkgs.playerctl
      ]
    })
  '';
}
