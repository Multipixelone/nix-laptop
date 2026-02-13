{ inputs, ... }:
{
  # Disable systemd-resolved to allow blocky to bind to port 53
  services.resolved.enable = false;

  services.blocky = {
    enable = true;
    settings = {
      # Port configuration - listen on 53 for client queries
      ports.dns = [
        "127.0.0.1:53"
        "10.100.0.1:53"
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
}
