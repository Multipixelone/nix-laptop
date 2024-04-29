{pkgs, ...}: {
  stylix.targets.waybar.enable = false;
  stylix.targets.kde.enable = false;
  gtk = {
    enable = true;
    theme = pkgs.lib.mkForce {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
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
