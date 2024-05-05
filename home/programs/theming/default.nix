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
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    #font = (pkgs.callPackage ../pkgs/pragmata/default.nix {});
  };
  home.packages = with pkgs; [
    (nerdfonts.override {fonts = ["FiraCode"];})
    (pkgs.callPackage ../../../pkgs/pragmata/default.nix {})
  ];
}
