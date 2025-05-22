{
  config,
  lib,
  ...
}: {
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
      options = ["subvol=/@home" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache"];
    };
    # extra drives!
    "/media/TeraData" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@games" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/media/Data" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@data" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/home/tunnel/Games/ROMs" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@roms" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/volume1/Media" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@data" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/media/BigData" = {
      device = "/dev/disk/by-label/BigData";
      fsType = "btrfs";
      options = ["subvol=/" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/media/SlowData" = {
      device = "/dev/disk/by-label/SlowData";
      fsType = "btrfs";
      options = ["subvol=/" "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag"];
    };
  };
}
