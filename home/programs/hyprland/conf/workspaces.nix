{
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    workspace = [
      "5,gapsin:10,gapsout:20"
      "4, on-created-empty: obsidian,gapsin:0,gapsout:0,border:false,rounding:false"
      "workspace = 1,monitor: DP-1,default:true"
      "workspace = 2,monitor: DP-1"
      "workspace = 3,monitor: DP-1"
      "workspace = 4,monitor: DP-1"
      "workspace = 5,monitor: DP-3"
      "workspace = 6,monitor: DP-3"
    ];
  };
}
