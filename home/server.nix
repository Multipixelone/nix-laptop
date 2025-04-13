{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
  ];
  home.packages = with pkgs; [
    sysstat
    just
    i2c-tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
    devenv
  ];
}
