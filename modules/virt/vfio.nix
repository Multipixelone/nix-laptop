{ config, ... }:
{
  flake.modules.nixos.laptop =
    { pkgs, ... }:
    {
      boot.extraModulePackages = with config.boot.kernelPackages; [ kvmfr ];
      boot.extraModprobeConfig = ''
        options kvmfr static_size_mb=64
      '';
      boot.kernelModules = [ "kvmfr" ];

      services.udev.extraRules = ''
        SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="systemd"
      '';
      boot.kernel.sysctl = {
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
      environment.etc."libvirt/hooks/qemu" = {
        source = pkgs.writeText "qemu" ''
          #!/usr/bin/env bash

          OBJECT="$1"
          OPERATION="$2"
          SUB_OPERATION="$3"
          EXTRA_ARG="$4"

          if [[ "$OBJECT" == "win11" ]]; then
              CORES=$(seq 0 15)

              if [[ "$OPERATION" == "prepare" ]]; then
                  echo "Hook: Setting performance governor for $OBJECT"
                  for core in $CORES; do
                      echo performance > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_governor
                  done

              elif [[ "$OPERATION" == "release" ]]; then
                  echo "Hook: Reverting to powersave governor for $OBJECT"
                  for core in $CORES; do
                      echo powersave > /sys/devices/system/cpu/cpu$core/cpufreq/scaling_governor
                  done
              fi
          fi
        '';
        mode = "0755";
      };
      virtualisation.libvirtd.qemu = {
        verbatimConfig = ''
          cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm",
            "/dev/kvmfr0"
          ]
          hugetlbfs_mount = "/dev/hugepages"
        '';
      };
    };
}
