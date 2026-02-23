{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "pragmata-pro";
  version = "0.827";

  src = fetchzip {
    url = "https://blusky.s3.us-west-2.amazonaws.com/pragmata.zip";
    stripRoot = false;
    hash = "sha256-p7Kvc1lpnqwu7HkyKottMKN8ZZoNDTDxeZJJT+nDilI=";
  };

  # only extract the variable font because everything else is a duplicate
  installPhase = ''
    runHook preInstall

    install -Dm644 PragmataPro_*.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/tonsky/FiraCode";
    description = "Monospace font with programming ligatures";
    longDescription = ''
      Fira Code is a monospace font extending the Fira Mono font with
      a set of ligatures for common programming multi-character
      combinations.
    '';
    license = licenses.ofl;
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
