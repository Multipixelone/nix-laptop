{
  systemd.tmpfiles.rules = [
    "d /srv/slskd 0770 tunnel users -"
  ];
  virtualisation.oci-containers.containers.slskd = {
    autoStart = true;
    image = "slskd/slskd:0.22.5";
    ports = ["5030:5030" "2234:2234"];
    user = "1000:100";
    # TODO find some universal way to declare these paths like my music library so that I can use a variable
    volumes = [
      "/srv/slskd:/app"
      "/media/Data/Music/:/music"
      "/media/Data/ImportMusic/slskd/:/downloads"
      "/media/Data/ImportMusic/InProgress:/incomplete"
    ];
    environment = {
      # TODO add soulseek password as agenix secret
      SLSKD_REMOTE_CONFIGURATION = "true";
      SLSKD_SHARED_DIR = "/music";
      SLSKD_DOWNLOAD_DIR = "/downloads";
      SLSKD_INCOMPLETE_DIR = "/incomplete";
      SLSKD_SLSK_LISTEN_PORT = "2234";
    };
  };
  security = {
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.systemd1.manage-units") {
                if (action.lookup("unit") == "podman-slskd.service") {
                    var verb = action.lookup("verb");
                    if (verb == "start" || verb == "stop") {
                        return polkit.Result.YES;
                    }
                }
            }
        });
      '';
    };
  };
}
