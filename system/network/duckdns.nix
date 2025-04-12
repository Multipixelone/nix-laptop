{inputs, ...}: {
  age.secrets = {
    "duckdns".file = "${inputs.secrets}/wireguard/duckdns.age";
  };
  chaotic.duckdns = {
    enable = true;
    domain = "frwgq.duckdns.org";
    environmentFile = config.age.secrets."duckdns".path;
  };
}
