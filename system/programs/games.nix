{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];
  boot = {
    kernelParams = [
      "tsc=reliable"
      "clocksource=tsc"
      "mitigations=off"
      "nowatchdog"
      "transparent_hugepages=always"
      "vm.compaction_proactiveness=0"
      "gpu_sched.sched_policy=0" # https://gitlab.freedesktop.org/drm/amd/-/issues/2516#note_2119750
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
    graphics = {
      # 32 bit support
      enable32Bit = true;
    };
  };
  environment.systemPackages = [
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    inputs.nix-gaming.packages.${pkgs.system}.winetricks-git
    inputs.humble-key.packages.${pkgs.system}.default
  ];
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
      ];
    config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
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
          ];
      };
    };
  };
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
