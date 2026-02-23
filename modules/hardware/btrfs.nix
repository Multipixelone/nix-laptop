{
  flake.modules = {
    nixos.base =
      { config, lib, ... }:
      {
        services = {
          fstrim.enable = true;
          btrfs.autoScrub.enable = lib.mkDefault (
            lib.any (fs: fs.fsType == "btrfs") (lib.attrValues config.fileSystems)
          );
        };
      };
  };
}
