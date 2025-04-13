{pkgs, ...}: {
  environment.systemPackages = [pkgs.xdg-utils];
  services.flatpak.enable = true;
  services.gvfs.enable = true;
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
