{pkgs, ...}: {
  stylix.targets.waybar.enable = false;
  stylix.targets.kde.enable = false;
  gtk = {
    enable = true;
    theme = pkgs.lib.mkForce {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        tweaks = ["rimless"];
        size = "compact";
        variant = "mocha";
      };
    };
    iconTheme = pkgs.lib.mkForce {
      package = pkgs.catppuccin-papirus-folders;
      name = "Papirus-Dark";
    };
    #font = (pkgs.callPackage ../pkgs/pragmata/default.nix {});
  };
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style = {
      name = "Catppuccin-Frappe-Dark";
      package = pkgs.catppuccin-kde.override {
        flavour = ["mocha"];
        accents = ["mauve"];
      };
    };
  };
  home.packages = with pkgs; [
    qt5.qttools
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
    breeze-icons
    (nerdfonts.override {fonts = ["FiraCode"];})
    (pkgs.callPackage ../../../pkgs/pragmata/default.nix {})
  ];
}
