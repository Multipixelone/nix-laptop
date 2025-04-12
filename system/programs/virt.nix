{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
    waydroid.enable = true;
    lxd.enable = true;
    # FIX figure out why rootless podman isn't working. Replace with docker for now
    podman = {
      enable = false;
      # dockerCompat = false;
      # autoPrune.enable = true;
      # defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      storageDriver = "btrfs";
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        dns = ["1.1.1.1"];
      };
    };
    vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 3;
        graphics = false;
      };
    };
  };
}
