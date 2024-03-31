{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "5,gapsin:10,gapsout:20"
      "4,gapsin:0,gapsout:0,border:false,rounding:false"
    ];
  };
}
