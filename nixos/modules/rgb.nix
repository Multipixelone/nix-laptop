{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    openrgb
  ];
  programs.coolercontrol.enable = true;
  services.udev.packages = [pkgs.openrgb];
  boot.kernelParams = ["acpi_enforce_resources=lax"];
  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  hardware.openrazer.enable = true;
  services.hardware.openrgb.enable = true;
}
