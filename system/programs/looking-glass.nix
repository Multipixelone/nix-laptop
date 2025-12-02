{ config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=64
  '';
  boot.kernelModules = [ "kvmfr" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="tunnel", GROUP="libvirtd", MODE="0660"
  '';
}
