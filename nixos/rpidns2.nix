{lib, ...}: {
  imports = [
    ./core.nix
    ./modules/tailscale.nix
  ];
  networking = {
    hostName = "rpidns2";
    interfaces.eth0.ipv4.addresses = [
      {
        address = "192.168.6.112";
        prefixLength = 24;
      }
    ];
    interfaces.eth0.useDHCP = false;
    defaultGateway = "192.168.6.1";
    #nameservers = ["192.168.6.111" "192.168.6.112"];
    nameservers = ["8.8.8.8" "4.4.4.4"];
  };
  swapDevices = [];
  networking.useDHCP = lib.mkDefault false;
}
