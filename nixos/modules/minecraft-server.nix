_:
let
  atm-folder = "/srv/games/mc-atm10";
in
{
  systemd.tmpfiles.rules = [
    "d ${atm-folder} 0770 tunnel users -"
    # "d /srv/games/velocity 0770 tunnel users -"
  ];
  # age.secrets = {
  #   "curseforge" = {
  #     file = "${inputs.secrets}/curseforge.age";
  #     mode = "400";
  #     owner = "tunnel";
  #     group = "users";
  #   };
  # };
  virtualisation.oci-containers.containers = {
    minecraft-atm10 = {
      autoStart = false;
      image = "itzg/minecraft-server:latest";
      ports = [ "25565:25565" ];
      # environmentFiles = [config.age.secrets."curseforge".path];
      environment = {
        EULA = "TRUE";
        ONLINE_MODE = "TRUE";
        MOD_PLATFORM = "AUTO_CURSEFORGE";
        # None of my api keys were working so this is the ferium one LOL
        CF_API_KEY = "$2a$10$sI.yRk4h4R49XYF94IIijOrO4i3W3dAFZ4ssOlNE10GYrDhc2j8K.";
        CF_PAGE_URL = "https://www.curseforge.com/minecraft/modpacks/all-the-mods-9";
        CF_FILENAME_MATCHER = "2.45";
        MEMORY = "10G";
      };
      volumes = [
        "${atm-folder}:/data"
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
