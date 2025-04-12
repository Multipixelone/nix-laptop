{
  inputs,
  pkgs,
}: {
  imports = [
    inputs.hyprland.nixosModules.default
  ];
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };
  # hint electron apps to run on wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
