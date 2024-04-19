{
  lib,
  config,
  pkgs,
  nix-gaming,
  stylix,
  inputs,
  ...
}: {
  imports = [
    ./core.nix
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    env = GDK_SCALE,2
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
    env = QT_SCALE_FACTOR,2
  '';
}
