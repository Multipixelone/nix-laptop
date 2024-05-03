{
  config,
  lib,
  ...
}: {
  imports = [
    ./core.nix
  ];
  networking = {
    hostName = "rpidns1";
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.6.111";
        prefixLength = 24;
      }
    ];
    interfaces.eth0.useDHCP = false;
    defaultGateway = "192.168.6.1";
    #nameservers = ["192.168.6.111" "192.168.6.112"];
    nameservers = ["8.8.8.8" "4.4.4.4"];
  };
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
    fsType = "btrfs";
    options = ["subvol=@" "compress=zstd:4" "ssd" "relatime" "discard=async"];
  };
  swapDevices = [];
  networking.useDHCP = lib.mkDefault false;
}
