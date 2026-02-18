{ config, ... }:
{
  flake.modules.homeManager.base = args: {
    home = {
      username = config.flake.meta.owner.username;
      homeDirectory = "/home/${config.flake.meta.owner.username}";
      # required options for quadlet-nix
      linger = true; # start pods before user logs in
      autoSubUidGidRange = true;
      extraOutputsToInstall = [
        "doc"
        "devdoc"
      ];
    };
    programs.home-manager.enable = true;
    systemd.user.startServices = "sd-switch";
  };
}
