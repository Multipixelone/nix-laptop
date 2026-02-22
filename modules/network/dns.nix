{
  flake.modules.nixos.pc =
    { lib, config, ... }:
    {
      # Disable systemd-resolved to allow blocky to bind to port 53
      services.resolved.enable = false;

      networking.nameservers = [
        "127.0.0.1"
        "::1"
      ];

      services.dnscrypt-proxy = {
        enable = true;
        settings = {
          listen_addresses = [
            "127.0.0.1:6000"
          ];
          ipv6_servers = true;
          require_dnssec = true;
          sources.public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            ];
            cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          };
        };
      };

      services.unbound = {
        enable = true;
        settings = {
          server = {
            # Listen on localhost for queries from pihole
            interface = [
              "127.0.0.1"
              "::1"
            ];
            port = 5335;

            # Enable IPv6
            do-ip6 = true;

            # Access control
            access-control = [
              "127.0.0.0/8 allow"
              "::1/128 allow"
            ];

            # Performance tuning
            num-threads = 2;
            msg-cache-slabs = 4;
            rrset-cache-slabs = 4;
            infra-cache-slabs = 4;
            key-cache-slabs = 4;

            # Cache settings
            cache-min-ttl = 3600;
            cache-max-ttl = 86400;

            # Privacy
            hide-identity = true;
            hide-version = true;

            # Forward all queries to dnscrypt-proxy
            do-not-query-localhost = false;
          };

          forward-zone = [
            {
              name = ".";
              forward-addr = [
                "127.0.0.1@6000"
                # "[::1]@6000"
              ];
            }
          ];
        };
      };

      # Ensure proper service ordering
      systemd.services.unbound = {
        after = [ "dnscrypt-proxy.service" ];
        requires = [ "dnscrypt-proxy.service" ];
      };

      services.blocky = {
        enable = true;
        settings = {
          # Port configuration - listen on 53 for client queries
          ports.dns = [
            "127.0.0.1:53"
            # I need some kind of toml metadata solution for my hosts. pleaseee
            (lib.mkIf (config.networking.hostName == "link") "10.100.0.1:53")
          ];

          # Upstream DNS servers - forward to unbound
          upstreams = {
            groups = {
              default = [
                "127.0.0.1:5335"
                "[::1]:5335"
              ];
            };
          };

          # Enable blocking of ads and tracking domains
          blocking = {
            denylists = {
              ads = [
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
              ];
              fakenews = [
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-only/hosts"
              ];
              gambling = [
                "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-only/hosts"
              ];
              # adult = [
              #   "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-only/hosts"
              # ];
            };

            clientGroupsBlock = {
              default = [
                "ads"
                "fakenews"
                "gambling"
                # "adult"
              ];
            };
            blockType = "zeroIp";
            blockTTL = "1m";
          };

          # Caching
          caching = {
            minTime = "5m";
            maxTime = "30m";
            prefetching = true;
          };
        };
      };

      # Ensure proper service ordering
      systemd.services.blocky = {
        after = [ "unbound.service" ];
        requires = [ "unbound.service" ];
      };

    };
}
