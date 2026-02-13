{ ... }:
{
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
}
