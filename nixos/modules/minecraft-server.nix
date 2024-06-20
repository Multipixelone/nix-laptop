{pkgs, ...}: let
in {
  systemd.tmpfiles.rules = [
    "d /srv/games/mc-unlimited 0770 tunnel users -"
    "d /srv/games/velocity 0770 tunnel users -"
  ];
  virtualisation.oci-containers.containers = {
    minecraft-server = {
      autoStart = true;
      image = "itzg/minecraft-server:latest";
      # ports = ["25565:25565"];
      environment = {
        EULA = "TRUE";
        # required for proxy use
        ONLINE_MODE = "FALSE";
        TYPE = "AUTO_CURSEFORGE";
        CF_SLUG = "hazardousdaniels-unlimited";
        # released jun 19th
        CF_FILE_ID = "5444071";
      };
      volumes = [
        "/srv/games/mc-unlimited:/data"
      ];
    };
    minecraft-proxy = {
      autoStart = true;
      image = "itzg/mc-proxy:latest";
      ports = ["25565:25577"];
      environment = {
        TYPE = "VELOCITY";
      };
      volumes = [
        "/srv/games/velocity:/server"
      ];
    };
  };
}
