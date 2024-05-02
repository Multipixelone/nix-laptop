{pkgs, ...}: {
  home.packages = with pkgs; [
    zotero
    texliveFull
    latexrun
  ];
}
