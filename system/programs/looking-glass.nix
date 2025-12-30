{ config, ... }:
{
  boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=64
  '';
  boot.kernelModules = [ "kvmfr" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="systemd"
  '';
  kernel.sysctl = {
    "vm.compaction_proactiveness" = 0;
  };
  boot.kernelParams = [
    # cpu isol
    "isolcpus=0-15"
    "nohz_full=0-15"
    "rcu_nocbs=0-15"
    # 20GB = 20 * 1024 / 2 = 10240 2MB pages (add buffer:  10500)
    "hugepagesz=2M"
    "hugepages=10500"
    "transparent_hugepage=never"
  ];
  systemd.mounts = [
    {
      what = "hugetlbfs";
      where = "/dev/hugepages";
      type = "hugetlbfs";
      options = "mode=0775,gid=libvirtd";
    }
  ];

}
