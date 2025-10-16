{ pkgs, ... }:
{
  programs.virt-manager.enable = true;
  environment.systemPackages = [ pkgs.distrobox ];
  virtualisation = {
    # oci-containers.backend = "docker";
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
    };
    waydroid.enable = true;
    quadlet.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
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
