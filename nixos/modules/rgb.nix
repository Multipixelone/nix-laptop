{pkgs, ...}: {
  programs.coolercontrol.enable = true;
  # boot.kernelParams = ["acpi_enforce_resources=lax"];
  # hardware.openrazer.enable = true;
  services.hardware.openrgb = {
    package = pkgs.openrgb-with-all-plugins;
    enable = true;
  };
}
