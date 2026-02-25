{ lib, ... }:
let
  wireguardSubmodule = lib.types.submodule {
    options = {
      ipv4Address = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "WireGuard IPv4 address for this host (without CIDR suffix).";
        example = "10.100.0.1";
      };
      publicKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "WireGuard public key for this host.";
      };
    };
  };

  hostSubmodule = lib.types.submodule (
    { name, ... }:
    {
      options = {
        hostName = lib.mkOption {
          type = lib.types.str;
          default = name;
          description = "Hostname of this host. Defaults to the attribute name.";
        };
        isNixOS = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Whether this host is managed as a NixOS configuration.";
        };
        roles = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = "Roles or tags describing this host (e.g. desktop, laptop, server, mobile).";
        };
        homeAddress = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Static home/LAN IPv4 address.";
          example = "192.168.6.6";
        };
        iotAddress = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "Static home/IoT IPv4 address.";
          example = "192.168.5.3";
        };
        wireguard = lib.mkOption {
          type = wireguardSubmodule;
          default = { };
          description = "WireGuard network configuration for this host.";
        };
      };
    }
  );
in
{
  options.hosts = lib.mkOption {
    type = lib.types.attrsOf hostSubmodule;
    default = { };
    description = "Central registry of all hosts and devices, including network metadata.";
  };

  config.hosts = {
    link = {
      isNixOS = true;
      roles = [ "desktop" ];
      homeAddress = "192.168.6.6";
      wireguard.ipv4Address = "10.100.0.1";
    };
    zelda = {
      isNixOS = true;
      roles = [ "laptop" ];
      wireguard = {
        ipv4Address = "10.100.0.2";
        publicKey = "8mNNHB03ytgnnZMPv0AZOpgZVumEvy3tr+E7h3WBCUI=";
      };
    };
    iot = {
      isNixOS = true;
      homeAddress = "192.168.8.111";
      iotAddress = "192.168.5.3";
      roles = [ "server" ];
    };
    marin = {
      isNixOS = true;
      roles = [ "server" ];
    };
    ipad = {
      roles = [ "tablet" ];
      wireguard = {
        ipv4Address = "10.100.0.50";
        publicKey = "YHW9LGJkWRaa5GtBCmqFd1IVS9fyVRUP3orDXeCC8l8=";
      };
    };
    iphone = {
      roles = [ "mobile" ];
      wireguard = {
        ipv4Address = "10.100.0.100";
        publicKey = "ORnW9c/rVHqOdaawcHJlpeTtg7pPvPxICtN2kXTlc3I=";
      };
    };
  };
}
