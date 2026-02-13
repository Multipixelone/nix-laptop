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
          H1 = 256;
          H2 = 512;
          H3 = 1024;
          H4 = 2048;
          Jc = 4;
          Jmax = 32;
          Jmin = 16;
          S1 = 16;
          S2 = 17;
          S3 = 18;
          S4 = 19;
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
