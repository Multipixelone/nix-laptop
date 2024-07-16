{pkgs, ...}: let
in {
  systemd.tmpfiles.rules = [
    "d /srv/games/mc-unlimited 0770 tunnel users -"
    "d /srv/games/velocity 0770 tunnel users -"
  ];
  virtualisation.oci-containers.containers = {
    minecraft-server = {
      autoStart = false;
      image = "itzg/minecraft-server:latest";
      ports = ["25565:25565"];
      environment = {
        EULA = "TRUE";
        # required for proxy use
        ONLINE_MODE = "TRUE";
        MOD_PLATFORM = "AUTO_CURSEFORGE";
        # CF_SLUG = "hazardousdaniels-unlimited";
        CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/hazardousdaniels-unlimited";
        CF_FILENAME_MATCHER = "1.2.1";
      };
      volumes = [
        "/srv/games/mc-unlimited:/data"
      ];
    };
    # minecraft-proxy = {
    #   autoStart = true;
    #   image = "itzg/mc-proxy:latest";
    #   ports = ["25565:25577"];
    #   environment = {
    #     TYPE = "VELOCITY";
    #   };
    #   volumes = [
    #     "/srv/games/velocity:/server"
    #   ];
    # };
  };
}
