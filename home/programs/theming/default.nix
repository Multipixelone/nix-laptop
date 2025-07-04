{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./wallpaper.nix
    inputs.catppuccin.homeModules.catppuccin
  ];
  catppuccin = {
    enable = true;
    flavor = "mocha";
    accent = "mauve";
  };
  stylix.targets = lib.mkForce {
    waybar.enable = false;
    hyprpaper.enable = false;
    hyprland.enable = false;
    hyprlock.enable = false;
    kde.enable = false;
    gtk.enable = false;
    mako.enable = false;
    spicetify.enable = false;
    fzf.enable = false;
    bat.enable = false;
    btop.enable = false;
    helix.enable = false;
    starship.enable = false;
    yazi.enable = false;
  };
  gtk = {
    enable = true;
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
    platformTheme.name = "kvantum";
    style = {
      name = "kvantum";
    };
  };
  home.packages = with pkgs; [
    qt5.qttools
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    libsForQt5.qt5ct
  ];
}
