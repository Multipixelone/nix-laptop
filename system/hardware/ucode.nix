{config, ...}: {
  services.ucodenix = {
    enable = config.hardware.enableRedistributableFirmware;
    cpuModelId = "00A20F10";
  };
}
