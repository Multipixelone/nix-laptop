{ inputs, ... }:
{
  services.blocky = {
    enable = true;
    settings = {
      # Port configuration - listen on 53 for client queries
      port = 53;
      
      # Upstream DNS servers - forward to unbound
      upstreams = {
        groups = {
          default = [
            "127.0.0.1:5335"
          ];
        };
      };
      
      # Enable blocking of ads and tracking domains
      blocking = {
        blockLists = {
          ads = [
            # Use the same blocklist that dnscrypt was using
            "${inputs.blocklist}/hosts"
          ];
        };
        # Add common ad/tracking domains
        clientGroupsBlock = {
          default = [ "ads" ];
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
