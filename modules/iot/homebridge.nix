{
  configurations.nixos.iot.module = {
    services.homebridge = {
      enable = true;
      openFirewall = true;
    };
  };
}
