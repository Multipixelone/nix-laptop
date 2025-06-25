{pkgs, ...}: let
  tag = "4.12.3";
  fromImageName = "plexamp";
  fromImage = pkgs.dockerTools.pullImage {
    imageName = "ghcr.io/multipixelone/${fromImageName}";
    imageDigest = "sha256:c94e72bf28127bc2148b3bc8849e85df4b24a5d48f3d8bf1745140a972aa0d63";
    hash = "sha256-YGlEJiQyssD2OwHoLpQJ93c4b5haJnhw9nfi8edK0sE=";
    finalImageName = fromImageName;
    finalImageTag = tag;
    # os = "linux";
    # arch = "amd64";
  };
  plexamp-docker = pkgs.dockerTools.buildImage {
    inherit fromImage fromImageName tag;
    name = "plexamp-headless";
    config = {
      Cmd = [
        (pkgs.writeScript "docker-entrypoint.sh" ''
          #!/usr/bin/env bash
          /usr/local/bin/node /home/root/plexamp/js/index.js
        '')
      ];
      Volumes = {
        "/tmp/snapfifo" = {};
        "/tmp/pipewire-0" = {};
      };
    };
  };
in {
  virtualisation.oci-containers.containers.plexamp-headless = {
    autoStart = true;
    image = plexamp-docker;
    ports = ["32400:32400/tcp"];
    volumes = [
      "/var/lib/plexamp:/config"
      "/run/user/1000/pipewire-0:/tmp/pipewire-0"
    ];
    environment = {
      XDG_RUNTIME_DIR = "/tmp";
    };
  };
}
