{ config, ... }:
let
  linkHost = config.hosts.link;
in
{
  configurations.nixos.link.module = {
    networking = {
      networkmanager.enable = false;
      interfaces.enp6s0.ipv4.addresses = [
        {
          address = linkHost.homeAddress;
          prefixLength = 24;
        }
      ];
      interfaces.enp6s0.useDHCP = false;
      useDHCP = false;
      defaultGateway = "192.168.6.1";
    };
  };
}
