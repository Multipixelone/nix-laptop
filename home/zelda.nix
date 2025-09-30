{ ... }:
{
  imports = [
    ./desktop.nix
  ];
  wayland.windowManager.hyprland.extraConfig = ''
    env = GDK_SCALE,2
  '';
}
