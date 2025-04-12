{
  lib,
  pkgs,
  ...
}: {
  boot = {
    plymouth = {
      enable = false;
      catppuccin.enable = false;
      theme = "nixos-bgrt";
      themePackages = with pkgs; [
        nixos-bgrt-plymouth
      ];
    };
    loader.grub = {
      enable = lib.mkDefault true;
      efiSupport = true;
      device = "nodev";
      # gfxmodeEfi = "3440x1440";
      # lib.mkForce font = true;
      # timeoutStyle = "hidden";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    # hide os choice
    loader.timeout = 0;
    kernel.sysctl = {
      "kernel.nmi_watchdog" = 0;
    };
    kernelParams = [
      # "quiet"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
      "nowatchdog"
      "hpet=disable"
      "transparent_hugepages=always"
      "vm.compaction_proactiveness=0"
    ];
    # xanmod or zen
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_cachyos;
  };
}
