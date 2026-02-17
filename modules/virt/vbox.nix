{
  nixpkgs.config.allowUnfreePackages = [ "Oracle_VirtualBox_Extension_Pack" ];
  flake.modules.nixos.pc =
    { flake, ... }:
    {
      users.extraGroups.vboxusers.members = [ flake.meta.owner.username ];
      virtualisation = {
        virtualbox.host = {
          enable = true;
          enableExtensionPack = true;
        };
      };
    };
}
