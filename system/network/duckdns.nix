{inputs, ...}: {
  age.secrets = {
    "duckdns".file = "${inputs.secrets}/wireguard/duckdns.age";
  };
}
