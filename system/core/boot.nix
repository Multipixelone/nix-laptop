{
  lib,
  pkgs,
  ...
}:
{
  boot = {
    plymouth = {
      enable = true;
      # theme = "nixos-bgrt";
      # themePackages = with pkgs; [
      #   nixos-bgrt-plymouth
      # ];
    };
    loader.limine = {
      enable = lib.mkDefault true;
      panicOnChecksumMismatch = true;
      style.wallpapers = [ ];
      additionalFiles = {
        "efi/memtest86+/memtest.efi" = "${pkgs.memtest86plus}/mt86plus.efi";
      };
      extraEntries = ''
        /Memtest86+
        	protocol: chainload
        	path: boot():///efi/memtest86+/memtest.efi
      '';
    };
    loader.grub = {
      enable = lib.mkDefault false;
      efiSupport = true;
      device = "nodev";
      # gfxmodeEfi = "3440x1440";
      # lib.mkForce font = true;
      # timeoutStyle = "hidden";
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    # hide os choice
    loader.timeout = 5;
    kernelParams = [
      # "quiet"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    # xanmod or zen
    # kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelPackages = lib.mkDefault pkgs.linuxPackages_xanmod_latest;
  };
}
