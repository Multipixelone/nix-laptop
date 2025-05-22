{
  config,
  lib,
  ...
}: let
  default-options = [
    "compress=zstd:3"
    # "relatime"
    "ssd"
    "discard=async"
    "space_cache"
  ];
in {
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage"];
    };
    kernelParams = [
      "video=DP-1:2560x1440@240"
      "video=DP-3:1920x1200@60"
    ];
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [{device = "/swap/swapfile";}];
  fileSystems = {
    "/boot/efi" = {device = "/dev/disk/by-uuid/9433-A195";};
    "/swap" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
      options = ["subvol=@swap"];
    };
    "/" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
      options = ["subvol=/@nixos" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache"];
    };
    "/home" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
      options = ["subvol=/@home" default-options];
    };
    # extra drives!
    "/media/TeraData" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@games" default-options];
    };
    "/media/Data" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@data" default-options];
    };
    "/home/tunnel/Games/ROMs" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@roms" default-options];
    };
    "/volume1/Media" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@data" default-options];
    };
    "/media/BigData" = {
      device = "/dev/disk/by-label/BigData";
      fsType = "btrfs";
      options = ["subvol=/" default-options];
    };
    "/media/SlowData" = {
      device = "/dev/disk/by-label/SlowData";
      fsType = "btrfs";
      options = ["subvol=/" "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag"];
    };
  };
}
