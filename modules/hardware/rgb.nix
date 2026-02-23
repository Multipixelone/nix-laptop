{ config, ... }:
{
  flake.modules.nixos.gaming = {
    users.extraGroups.i2c.members = [ config.flake.meta.owner.username ];
    programs.coolercontrol.enable = true;
    hardware.i2c.enable = true;
    boot.kernelParams = [ "acpi_enforce_resources=lax" ];
    # hardware.openrazer.enable = true;
    services.hardware.openrgb = {
      enable = true;
    };
  };
}
