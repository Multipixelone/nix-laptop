{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];
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
}
