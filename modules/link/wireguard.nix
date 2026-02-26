{
  config,
  lib,
  ...
}:
let
  inherit (config) hosts;
  linkHost = hosts.link;
  wgSubnet = "10.100.0.0/24";
  wgPeerHosts =
    hosts
    |> lib.filterAttrs (
      name: host: name != "link" && host.wireguard.publicKey != null && host.wireguard.ipv4Address != null
    );
in
{
  configurations.nixos.link.module =
    { pkgs, config, ... }:
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
            ips = [ "${linkHost.wireguard.ipv4Address}/24" ];
            listenPort = 443;
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${wgSubnet} -o enp6s0 -j MASQUERADE
            '';
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${wgSubnet} -o enp6s0 -j MASQUERADE
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

            peers = lib.mapAttrsToList (
              _name: host:
              {
                publicKey = host.wireguard.publicKey;
                allowedIPs = [ "${host.wireguard.ipv4Address}/32" ];
              }
              // lib.optionalAttrs host.isNixOS {
                presharedKeyFile = config.age.secrets."psk".path;
              }
            ) wgPeerHosts;
          };
        };
      };
    };
}
