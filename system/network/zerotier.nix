{
  networking.firewall.trustedInterfaces = [
    "ztfp6fg5uh"
  ];
  services.zerotierone = {
    enable = true;
    joinNetworks = ["52b337794f640fc8"];
  };
}
