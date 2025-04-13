{
  inputs,
  config,
  ...
}: {
  age.secrets = {
    "wireguard".file = "${inputs.secrets}/wireguard/${config.networking.hostName}.age";
    "psk".file = "${inputs.secrets}/wireguard/psk.age";
  };
  networking.firewall.trustedInterfaces = [
    "wg0"
  ];
}
