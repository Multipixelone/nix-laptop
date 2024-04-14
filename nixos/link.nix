{
  config,
  pkgs,
  lib,
  inputs,
  stylix,
  ...
}: {
  imports = [
    ./core.nix
    ./modules/gamemode.nix
    ./modules/rgb.nix
  ];
  hardware.i2c.enable = true;

  networking.useDHCP = lib.mkDefault false;
  hardware.opengl.driSupport = true; # This is already enabled by default
  hardware.opengl.driSupport32Bit = true; # For 32 bit applications
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  environment.systemPackages = [
    (import ./modules/scripts/ipodlink.nix {inherit pkgs;})
    (import ./modules/scripts/streammon.nix {inherit pkgs;})
    (import ./modules/scripts/sleep.nix {inherit pkgs;})
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
  ];
  services.udev.extraRules = ''
    # Operator Core
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="123B", MODE="0666"

    # Operator Sync
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="123C", MODE="0666"

    # GB Operator (release)
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="123D", MODE="0666"

    # SN Operator
    SUBSYSTEM=="usb", ATTR{idVendor}=="16d0", ATTR{idProduct}=="123E", MODE="0666"

    # Legacy or internal prototypes
    SUBSYSTEM=="usb", ATTR{idVendor}=="1d50", ATTR{idProduct}=="6018", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="1209", ATTR{idProduct}=="db42", MODE="0666"
  '';
  boot.initrd = {
    availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage"];
    kernelModules = ["amdgpu"];
  };
  boot.kernelModules = ["kvm-amd" "vfio-pci" "uinput"];
  boot.kernelParams = [
    "video=DP-1:2560x1440@240"
    "video=DP-3:1920x1200@60"
  ];
  boot.loader.efi = {
    efiSysMountPoint = "/boot/efi";
    canTouchEfiVariables = true;
  };
  networking.firewall.allowedTCPPorts = [22 5900 8384 22000 47984 47989 48010 59999];
  networking.firewall.allowedUDPPorts = [22000 21027 47998 47999 48000 48002 48010];
  networking = {
    interfaces.enp6s0.ipv4.addresses = [
      {
        address = "192.168.6.6";
        prefixLength = 24;
      }
    ];
    interfaces.enp6s0.useDHCP = false;
    defaultGateway = "192.168.6.1";
    #nameservers = ["192.168.6.111" "192.168.6.112"];
    nameservers = ["8.8.8.8" "4.4.4.4"];
  };
  networking.hostName = "link";
  nixpkgs.config.packageOverrides = pkgs: {
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
  services.syncthing = {
    enable = true;
    user = "tunnel";
    configDir = "/home/tunnel/.config/syncthing";
  };
  fileSystems."/boot/efi" = {device = "/dev/disk/by-uuid/9433-A195";};
  fileSystems."/swap" = {
    device = "/dev/disk/by-label/Linux";
    fsType = "btrfs";
    options = ["subvol=@swap"];
  };
  swapDevices = [{device = "/swap/swapfile";}];
  fileSystems."/" = {
    device = "/dev/disk/by-label/Linux";
    fsType = "btrfs";
    options = ["subvol=/@nixos" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache"];
  };
  fileSystems."/home" = {
    device = "/dev/disk/by-label/Linux";
    fsType = "btrfs";
    options = ["subvol=/@home" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache"];
  };
  #fileSystems."/media/Arch" =
  #  { device = "/dev/disk/by-label/SlowData";
  #    fsType = "btrfs";
  #    options = [ "subvol=/@Arch" "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag" ];
  #  };
  fileSystems."/media/Data" = {
    device = "/dev/disk/by-label/Data";
    fsType = "btrfs";
    options = ["subvol=/" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/volume1/Media" = {
    device = "/dev/disk/by-label/Data";
    fsType = "btrfs";
    options = ["subvol=/" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/media/BigData" = {
    device = "/dev/disk/by-label/BigData";
    fsType = "btrfs";
    options = ["subvol=/" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
  };
  fileSystems."/media/SlowData" = {
    device = "/dev/disk/by-label/SlowData";
    fsType = "btrfs";
    options = ["subvol=/" "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag"];
  };
  fileSystems."/media/Windows" = {
    device = "/dev/disk/by-label/Windows";
    fsType = "ntfs";
    options = ["nosuid" "nodev" "relatime" "blksize=4096"];
  };
}
