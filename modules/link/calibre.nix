{ config, ... }:
{
  configurations.nixos.link.module = {
    services.calibre-web = {
      enable = true;
      user = config.flake.meta.owner.username;
      group = "users";
      listen.ip = "0.0.0.0";
      openFirewall = true;
      options = {
        calibreLibrary = "/home/${config.flake.meta.owner.username}/Calibre Library";
        enableBookUploading = true;
      };
    };
  };
}
