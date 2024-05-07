{pkgs, ...}: let
  # TODO Make these happen with power plug + unplug
  # TODO Module settings for laptop mode
  pretty-enable = pkgs.writeShellApplicationBin {
    name = "pretty-enable";
    runtimeInputs = [pkgs.hyprctl];
    text = ''
      hyprctl keyword animations:enabled true
      hyprctl keyword decoration:blur:enabled true
      hyprctl keyword decoration:drop_shadow true
    '';
  };
  pretty-disable = pkgs.writeShellApplicationBin {
    name = "pretty-disable";
    runtimeInputs = [pkgs.hyprctl];
    text = ''
      hyprctl keyword animations:enabled false
      hyprctl keyword decoration:blur:enabled false
      hyprctl keyword decoration:drop_shadow false
    '';
  };
in {
}
