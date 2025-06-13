{pkgs, ...}: {
  programs.coolercontrol.enable = true;
  hardware.i2c.enable = true;
  boot.kernelParams = ["acpi_enforce_resources=lax"];
  # hardware.openrazer.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb;
  };
}
