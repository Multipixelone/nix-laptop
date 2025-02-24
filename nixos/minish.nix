{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
  ];
  # specialisation = {
  #   nvidia-sync.configuration = {
  #     imports = [
  #       inputs.nix-hardware.nixosModules.dell-xps-15-9560-nvidia
  #     ];
  #     hardware.nvidia = {
  #       open = false;
  #       prime = {
  #         sync.enable = lib.mkForce true;
  #         offload = {
  #           enable = lib.mkForce false;
  #           enableOffloadCmd = lib.mkForce false;
  #         };
  #       };
  #     };
  #   };
  # };
  # power management stuff
  # Syncthing
}