{
  pkgs,
  config,
  ...
}:
{
  networking = {
    firewall = {
      allowedUDPPorts = [ 443 ];
      trustedInterfaces = [ "wg0" ];
    };
    nat = {
      enable = true;
      externalInterface = "enp6s0";
      internalInterfaces = [ "wg0" ];
    };
    wireguard.interfaces = {
      wg0 = {
        type = "amneziawg";
        ips = [ "10.100.0.1/24" ];
        listenPort = 443;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
        '';
        privateKeyFile = config.age.secrets."wireguard".path;

        extraOptions = {
          # Header obfuscation
          H1 = 3552562;
          H2 = 3289397;
          H3 = 7481934;
          H4 = 5765241;
          # Junk packets
          Jc = 5;
          Jmin = 50;
          Jmax = 500;
          # Packet size padding
          S1 = 71;
          S2 = 93;
          S3 = 47;
          S4 = 62;
        };

        peers = [
          {
            # zelda
            publicKey = "8mNNHB03ytgnnZMPv0AZOpgZVumEvy3tr+E7h3WBCUI=";
            presharedKeyFile = config.age.secrets."psk".path;
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            # ipad
            publicKey = "YHW9LGJkWRaa5GtBCmqFd1IVS9fyVRUP3orDXeCC8l8=";
            allowedIPs = [ "10.100.0.50/32" ];
          }
        ];
      };
    };
  };
}
