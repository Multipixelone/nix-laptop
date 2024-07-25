{pkgs, ...}: let
in {
  systemd.tmpfiles.rules = [
    "d /srv/games/velocity 0770 tunnel users -"
    "d /srv/games/mc-atm9 0770 tunnel users -"
  ];
  virtualisation.oci-containers.containers = {
    minecraft-atm9 = {
      autoStart = false;
      image = "itzg/minecraft-server:latest";
      ports = ["25565:25565"];
      environment = {
        EULA = "TRUE";
        # required for proxy use
        ONLINE_MODE = "TRUE";
        MOD_PLATFORM = "AUTO_CURSEFORGE";
        # CF_SLUG = "hazardousdaniels-unlimited";
        CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/all-the-mods-9";
        CF_FILENAME_MATCHER = "0.3.0";
      };
      volumes = [
        "/srv/games/mc-atm9:/data"
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
