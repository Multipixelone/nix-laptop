{ config, ... }:
{
  flake.modules.nixos.laptop =
    { pkgs, ... }:
    {
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
      boot.initrd = {
        availableKernelModules = [
          "virtio_net"
          "virtio_pci"
          "virtio_mmio"
          "virtio_blk"
          "virtio_scsi"
        ];
        kernelModules = [
          "virtio_balloon"
          "virtio_console"
          "virtio_rng"
        ];
      };

    };
}
