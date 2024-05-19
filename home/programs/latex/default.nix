{pkgs, ...}: {
  home.packages = with pkgs; [
    zotero
    texliveFull
    latexrun
    # TODO Maybe move Libreoffice to some other kind of general editing module? This just seemed like the most sensible place rn
    libreoffice-fresh
    jdk # Needed for libreoffice?
  ];
}
