{ lib, ... }:
{
  flake.modules.nixos.base = {
    services.resolved = {
      enable = lib.mkDefault true;
      settings.Resolve = {
        DNSSEC = "allow-downgrade";
        DNSOverTLS = "opportunistic";
        DNS = [
          # https://developers.cloudflare.com/1.1.1.1
          "1.1.1.1#cloudflare-dns.com"
          "1.0.0.1#cloudflare-dns.com"
          "2606:4700:4700::1111#cloudflare-dns.com"
          "2606:4700:4700::1001#cloudflare-dns.com"

          # https://developers.google.com/speed/public-dns/docs/using
          "8.8.8.8#dns.google"
          "8.8.4.4#dns.google"
          "2001:4860:4860::8888#dns.google"
          "2001:4860:4860::8844#dns.google"
        ];
      };
    };
  };
}
