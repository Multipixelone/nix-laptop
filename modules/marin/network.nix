{
  pkgs,
  ...
}:
{

  configurations.nixos.marin.module = {
    # nh default flake
    environment.variables.NH_FLAKE = "/home/tunnel/nix-laptop";

    networking = {
      nameservers = [
        "8.8.8.8"
        "1.1.1.1"
      ];
      interfaces.enp3s0f0.ipv4.addresses = [
        {
          address = "192.168.7.3";
          prefixLength = 24;
        }
      ];
      interfaces.wlp2s0.ipv4.addresses = [
        {
          address = "192.168.5.21";
          prefixLength = 24;
        }
      ];
      # defaultGateway = {
      #   address = "192.168.7.1";
      #   interface = "enp3s0f0";
      # };
      defaultGateway = {
        address = "192.168.5.1";
        interface = "wlp2s0";
      };
    };
  };
}
