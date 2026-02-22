{
  configurations.nixos.link.module = {
    # hint epp to use maximum cpu performance
    powerManagement.cpuFreqGovernor = "performance";

    services.ucodenix = {
      enable = true;
      cpuModelId = "00A20F10";
    };
  };
}
