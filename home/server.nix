{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./secrets.nix
    inputs.nix-index-database.hmModules.nix-index
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
  home.stateVersion = "23.11";
}
