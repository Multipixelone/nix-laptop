# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd:4" "ssd" "relatime" "discard=async"];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
    fsType = "btrfs";
    options = ["subvol=@home" "compress=zstd:4" "ssd" "relatime" "discard=async"];
  };
  fileSystems."/home/tunnel/Music/Library" = {
    device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
    fsType = "btrfs";
    options = ["subvol=@music" "compress=zstd:4" "ssd" "relatime" "discard=async"];
  };
  fileSystems."/home/tunnel/tmp" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=2G" "mode=755"];
  };
  fileSystems."/media/Data/Music" = {
    device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
    fsType = "btrfs";
    options = ["subvol=@music" "compress=zstd:4" "ssd" "relatime" "discard=async"];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/6164-2046";
    fsType = "vfat";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
