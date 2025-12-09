{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.nix-gaming.nixosModules.wine
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];
  nixpkgs.overlays = [
    inputs.prismlauncher.overlays.default
  ];
  boot = {
    kernelParams = [
      "tsc=reliable"
      "clocksource=tsc"
      "mitigations=off"
      "nowatchdog"
      "transparent_hugepages=always"
      "vm.compaction_proactiveness=0"
      # "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
    ];
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 600000;
      "kernel.nmi_watchdog" = 0;
      # https://github.com/CachyOS/CachyOS-Settings/blob/master/usr/lib/sysctl.d/99-cachyos-settings.conf
      "fs.file-max" = 2097152;
      "net.core.netdev_max_backlog" = 4096;
      "vm.dirty_background_bytes" = 67108864;
      "vm.dirty_bytes" = 268435456;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
    };
  };
  chaotic.mesa-git.enable = true;
  hardware = {
    steam-hardware.enable = true;
    graphics = {
      # 32 bit support
      enable32Bit = true;
    };
  };
  # vr stuff
  services.monado = {
    enable = true;
    defaultRuntime = true;
  };
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
  # programs.envision.enable = true;
  environment.systemPackages = [
    # inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    inputs.nix-gaming.packages.${pkgs.system}.winetricks-git
    pkgs.prismlauncher
    # inputs.humble-key.packages.${pkgs.system}.default
  ];
  systemd.tmpfiles.rules = [
    # https://wiki.archlinux.org/title/Gaming#Make_the_changes_permanent
    "w /proc/sys/vm/compaction_proactiveness - - - - 0"
    "w /proc/sys/vm/watermark_boost_factor - - - - 1"
    "w /proc/sys/vm/min_free_kbytes - - - - 1048576"
    "w /proc/sys/vm/watermark_scale_factor - - - - 500"
    "w /sys/kernel/mm/lru_gen/enabled - - - - 5"
    "w /proc/sys/vm/zone_reclaim_mode - - - - 0"
    "w /proc/sys/vm/page_lock_unfairness - - - - 1"
    "w /proc/sys/kernel/sched_child_runs_first - - - - 0"
    "w /proc/sys/kernel/sched_autogroup_enabled - - - - 1"
    "w /proc/sys/kernel/sched_cfs_bandwidth_slice_us - - - - 3000"
    "w /sys/kernel/debug/sched/base_slice_ns  - - - - 3000000"
    "w /sys/kernel/debug/sched/migration_cost_ns - - - - 500000"
    "w /sys/kernel/debug/sched/nr_migrate - - - - 8"
  ];
  nixpkgs = {
    config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
      ];
    config.packageOverrides = pkgs: {
      steam =
        let
          patchedBwrap = pkgs.bubblewrap.overrideAttrs (o: {
            patches = (o.patches or [ ]) ++ [
              ./bwrap.patch
            ];
          });
        in
        pkgs.steam.override {
          # buildFHSEnv = (
          #   args:
          #   (
          #     (pkgs.buildFHSEnv.override {
          #       bubblewrap = patchedBwrap;
          #     })
          #     (
          #       args
          #       // {
          #         extraBwrapArgs = (args.extraBwrapArgs or [ ]) ++ [ "--cap-add ALL" ];
          #       }
          #     )
          #   )
          # );
          extraProfile = ''
            # Fixes timezones
            unset TZ
            # Allows Monado to be used
            export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
          '';
          extraPkgs =
            pkgs: with pkgs; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
              # Steam VR
              procps
              usbutils
            ];
        };
    };
  };
  programs.wine = {
    enable = true;
    # package = inputs.nix-gaming.packages.${pkgs.system}.wine-cachyos;
    package = pkgs.wine-staging;
    binfmt = true;
    ntsync = true;
  };
  programs.alvr.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    platformOptimizations.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
