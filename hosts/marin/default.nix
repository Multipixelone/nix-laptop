{lib, ...}: {
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking = {
    hostName = "marin";
    useDHCP = false;
    interfaces.enp3s0f0.ipv4.addresses = [
      {
        address = "192.168.7.3";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.7.1";
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-id/dm-uuid-LVM-gWVEE2JcjOfdXFfqFulTflOiq27lhC6ccOexhOpZXOW7qL1dBM67aCOSezPYimi9";
      fsType = "ext4";
      options = ["default"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/a4b3ca17-0a5d-42f8-b48c-520053b3454e";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/4F36-2B33";
      fsType = "vfat";
    };
  };
}
