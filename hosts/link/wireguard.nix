{
  pkgs,
  config,
  ...
}:
{
  firewall.allowedUDPPorts = [ 443 ];
  networking = {
    nat = {
      enable = true;
      externalInterface = "enp6s0";
      internalInterfaces = [ "wg0" ];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];
        listenPort = 443;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
        '';
        privateKeyFile = config.age.secrets."wireguard".path;
        peers = [
          {
            # zelda
            publicKey = "8mNNHB03ytgnnZMPv0AZOpgZVumEvy3tr+E7h3WBCUI=";
            presharedKeyFile = config.age.secrets."psk".path;
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            # nougat
            publicKey = "CgAqN+0T70Exkduy1j0IyOHThHSSIPUmFPzdupLXUUk=";
            allowedIPs = [ "10.100.0.50/32" ];
          }
        ];
      };
    };
  };
}
