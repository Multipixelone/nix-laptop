{ config, ... }:
{
  nixpkgs.config.allowUnfreePackages = [
    "virtualbox-extpack"
    "Oracle_VirtualBox_Extension_Pack"
  ];
  flake.modules.nixos.pc = {
    users.extraGroups.vboxusers.members = [ config.flake.meta.owner.username ];
    virtualisation = {
      virtualbox.host = {
        enable = true;
        enableExtensionPack = true;
      };
    };
  };
}
