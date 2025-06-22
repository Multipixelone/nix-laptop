{pkgs, ...}: {
  programs.virt-manager.enable = true;
  environment.systemPackages = [pkgs.distrobox];
  virtualisation = {
    # oci-containers.backend = "docker";
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          # re-enable if tpm or secure boot is needed
          # packages = [
          #   (pkgs.OVMF.override {
          #     secureBoot = true;
          #     tpmSupport = true;
          #   })
          #   .fd
          # ];
        };
      };
    };
    waydroid.enable = true;
    lxd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
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
