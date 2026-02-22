{
  flake.modules = {
    nixos.base = {
      services = {
        fstrim.enable = true;
        btrfs.autoScrub.enable = true;
      };
    };
  };
}
