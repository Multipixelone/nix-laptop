{...}: {
  imports = [
    ./desktop.nix
    ./programs/gaming/default.nix
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    env = GDK_SCALE,2
    env = QT_AUTO_SCREEN_SCALE_FACTOR,1
  '';
}
