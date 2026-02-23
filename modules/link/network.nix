{
  configurations.nixos.link.module = {
    networking = {
      networkmanager.enable = false;
      interfaces.enp6s0.ipv4.addresses = [
        {
          address = "192.168.6.6";
          prefixLength = 24;
        }
      ];
      interfaces.enp6s0.useDHCP = false;
      useDHCP = false;
      defaultGateway = "192.168.6.1";
    };
  };
}
