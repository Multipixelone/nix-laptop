{
  configurations.nixos.link.module = {
    services.ucodenix = {
      enable = true;
      cpuModelId = "00A20F10";
    };
  };
}
