{
  pkgs,
  lib,
  ...
}: let
  # latexrun wrapped w/ args & copy synctex into root
  latexrun-wrapped = pkgs.writeShellScriptBin "latexrun" ''
    ${lib.getExe pkgs.latexrun} --bibtex-cmd "${pkgs.texliveFull}/bin/biber" --latex-args=-synctex=1 "$1"
    SYNCTEX_FILE=$(find latex.out/ -name "*.synctex.gz")
    cp $SYNCTEX_FILE .
  '';
in {
  home.packages = with pkgs; [
    zotero
    texliveFull
    latexrun-wrapped
    texlab
    # TODO Maybe move Libreoffice to some other kind of general editing module? This just seemed like the most sensible place rn
    libreoffice-fresh
    jdk # Needed for libreoffice?
  ];
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      zoom-min = "10";
      guioptions = "none";
    };
  };
}
