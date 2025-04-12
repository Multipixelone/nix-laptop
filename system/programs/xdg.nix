{pkgs, ...}: {
  xdg = {
    portal = {
      enable = true;
      # wlr.enable = false;
      config = {
        common.default = ["gtk"];
        hyprland.default = ["gtk" "hyprland"];
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
}
