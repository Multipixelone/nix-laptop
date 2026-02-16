{ pkgs, ... }:
{
  virtualisation = {
    # oci-containers.backend = "docker";
    quadlet.enable = true;
    containers.storage.settings.storage = {
      driver = "overlay";
    };
    # FIX figure out why rootless podman isn't working. Replace with docker for now
    # docker = {
    #   autoPrune.enable = true;
    #   rootless = {
    #     enable = true;
    #     setSocketVariable = true;
    #   };
    #   daemon.settings = {
    #     dns = ["1.1.1.1"];
    #   };
    # };
    vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 3;
        graphics = false;
      };
    };
  };
}
