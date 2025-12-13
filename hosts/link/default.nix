{
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.ucodenix.nixosModules.default
    ./hardware-configuration.nix
    ./hyprland.nix
    ./valhalla.nix
    ./wireguard.nix
    ./ollama.nix
    ./printer.nix
    ./snapclient.nix
  ];

  boot = {
    # kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "kvm-amd"
      "vfio-pci"
      "uinput"
    ];
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  # uncomment for plasma if you want LOL
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.greetd.enable = lib.mkForce false;

  # hint epp to use maximum cpu performance
  powerManagement.cpuFreqGovernor = "performance";

  # fan control
  hardware.amdgpu.overdrive.enable = true;
  # FIXME service not starting for some reason?
  # services.lact.enable = true;

  # console readability
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [ terminus_font ];
    keyMap = "us";
  };

  # network address & hostname
  networking = {
    hostName = "link";
    interfaces.enp6s0.ipv4.addresses = [
      {
        address = "192.168.6.6";
        prefixLength = 24;
      }
    ];
    interfaces.enp6s0.useDHCP = false;
    useDHCP = false;
    defaultGateway = "192.168.6.1";
  };

  security.tpm2.enable = true;

  services = {
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
    syncthing = {
      enable = true;
      user = "tunnel";
      configDir = "/home/tunnel/.config/syncthing";
    };
  };
}
