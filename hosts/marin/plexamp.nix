_:
# tag = "4.12.3";
# fromImageName = "plexamp";
# fromImage = pkgs.dockerTools.pullImage {
#   imageName = "ghcr.io/multipixelone/${fromImageName}";
#   imageDigest = "sha256:c94e72bf28127bc2148b3bc8849e85df4b24a5d48f3d8bf1745140a972aa0d63";
#   hash = "sha256-YGlEJiQyssD2OwHoLpQJ93c4b5haJnhw9nfi8edK0sE=";
#   finalImageName = fromImageName;
#   finalImageTag = tag;
#   # os = "linux";
#   # arch = "amd64";
# };
# plexamp-docker = pkgs.dockerTools.buildImage {
#   inherit fromImage fromImageName tag;
#   name = "plexamp-headless";
#   config = {
#     Cmd = [
#       (pkgs.writeScript "docker-entrypoint.sh" ''
#         #!/usr/bin/env bash
#         /usr/local/bin/node /home/root/plexamp/js/index.js
#       '')
#     ];
#     Volumes = {
#       "/tmp/snapfifo" = {};
#       "/tmp/pipewire-0" = {};
#     };
#   };
# };
{
  # create config folder
  systemd.tmpfiles.rules = [
    "d /srv/plexamp 0770 tunnel users -"
  ];
  virtualisation.oci-containers.containers.plexamp-headless = {
    # this was moved to quadlet because running as a user didn't work
    autoStart = false;
    # custom image with pipewire installed
    image = "ghcr.io/multipixelone/plexamp:amd64";
    # allow client discovery
    ports = [
      "32400:32400"
      "32500:32500"
      "20000:20000"
    ];
    user = "1000:100";
    volumes = [
      "/srv/plexamp:/root/.local/share/Plexamp/Settings"
      "/run/user/1000/pipewire-0:/tmp/pipewire-0"
      # "/run/dbus/system_bus_socket:/run/dbus/system_bus_socket"
    ];
    environment = {
      XDG_RUNTIME_DIR = "/tmp";
    };
  };
}
