{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./wallpaper.nix
  ];
  stylix.targets = {
    waybar.enable = false;
    kde.enable = false;
    gtk.enable = false;
  };
  gtk = {
    enable = true;
    theme = lib.mkForce {
      name = "Catppuccin-Mocha-Compact-Mauve-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["mauve"];
        tweaks = ["rimless"];
        size = "compact";
        variant = "mocha";
      };
    };
    iconTheme = lib.mkForce {
      package = pkgs.catppuccin-papirus-folders;
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    gtk2.extraConfig = ''
      gtk-xft-antialias=1
      gtk-xft-hinting=1
      gtk-xft-hintstyle="hintslight"
      gtk-xft-rgba="rgb"
    '';
    #font = (pkgs.callPackage ../pkgs/pragmata/default.nix {});
  };
  qt = {
    enable = true;
    platformTheme.name = "qt5ct";
    style = {
      name = "Catppuccin-Mocha-Dark";
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
    minecraftia
    corefonts
    vistafonts
    (nerdfonts.override {fonts = ["FiraCode"];})
    (pkgs.callPackage ../../../pkgs/pragmata/default.nix {})
    (pkgs.callPackage ../../../pkgs/apple-fonts/default.nix {})
  ];
}
