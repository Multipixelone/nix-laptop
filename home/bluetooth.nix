{...}: let
  headphones = "BC:87:FA:27:F5:4C";
  bc = "bluetoothctl connect ${headphones}";
  bd = "bluetoothctl disconnect ${headphones}";
in {
  programs.fish.shellAbbrs = {
    hpc = "${bc}";
    hpd = "${bd}";
  };
  wayland.windowManager.hyprland.settings.bind = [
    "Control_L, XF86AudioRaiseVolume, exec, ${bc}"
    "Control_L, XF86AudioLowerVolume, exec, ${bd}"
  ];
}
