  # TODO fix openrgb, or figure out why it causes microstutters w audio
  # environment.systemPackages = with pkgs; [
  #   openrgb
  # ];
{pkgs, ...}: {
  programs.coolercontrol.enable = true;
  boot.kernelParams = ["acpi_enforce_resources=lax"];
  boot.kernelModules = ["i2c-dev" "i2c-piix4"];
  # hardware.openrazer.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = pkgs.openrgb-with-all-plugins;
  };
}
