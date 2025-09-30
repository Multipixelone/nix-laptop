{ config, ... }:
{
  boot.kernelParams = [ "microcode.amd_sha_check=off" ];
  services.ucodenix = {
    enable = config.hardware.enableRedistributableFirmware;
    cpuModelId = "00A20F10";
  };
}
