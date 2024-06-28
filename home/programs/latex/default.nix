{pkgs, ...}: {
  home.packages = with pkgs; [
    zotero
    texliveFull
    latexrun
    # TODO Maybe move Libreoffice to some other kind of general editing module? This just seemed like the most sensible place rn
    libreoffice-fresh
    jdk # Needed for libreoffice?
  ];
  programs.zathura = {
    enable = true;
    options = {
      recolor = false;
      adjust-open = "best-fit";
      pages-per-row = "1";
      scroll-page-aware = "true";
      scroll-full-overlap = "0.01";
      scroll-step = "100";
      smooth-scroll = true;
      zoom-min = "10";
      guioptions = "none";
    };
  };
}
