{ config, ... }:
{
  flake.modules.nixos.laptop = {
    hardware.brillo.enable = true;
    hardware.acpilight.enable = true;
    users.extraGroups.video.members = [ config.flake.meta.owner.username ];
  };
}
