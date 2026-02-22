{
  configurations.nixos.link.module = {
    # fan control
    hardware.amdgpu.overdrive.enable = true;

    boot = {
      kernelModules = [
        "kvm-amd"
        "vfio-pci"
        "uinput"
      ];
      kernelParams = [
        "amd_pstate=active"
      ];
    };
  };
}
