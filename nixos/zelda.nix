{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
    inputs.nix-hardware.nixosModules.dell-xps-15-9560
  ];
  specialisation = {
    nvidia-sync.configuration = {
      imports = [
        inputs.nix-hardware.nixosModules.dell-xps-15-9560-nvidia
      ];
      hardware.nvidia = {
        open = false;
        prime = {
          sync.enable = lib.mkForce true;
          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
      };
    };
  };
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel"];
    extraModprobeConfig = ''
      options snd_hda_intel power_save=5
      options iwlwifi power_save=1
    '';
    extraModulePackages = [];
    loader = {
      systemd-boot.enable = true;
      grub.enable = false;
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
    };
  };
  # power management stuff
  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
  # Syncthing
  services.syncthing = {
    enable = true;
    user = "tunnel";
    configDir = "/home/tunnel/.config/syncthing";
    overrideDevices = true;
    overrideFolders = true;
    settings = {
      devices = {
        "link" = {id = "XOMPLRL-64GMF4T-P4SQ4XN-GCG26C2-3BKWACO-4DSWVCW-BU755ZU-KOJUDQ2";};
        "alexandria" = {id = "RBYKQEM-33KIP3W-D6KE3OD-V66VRWA-O6HZMFD-PKBWCWI-FZF6JD7-IZGLHAK";};
        "deck" = {id = "WPTWVQC-SJIKJOM-6SXC474-A6AJXVA-CBS5WQB-SREKAIH-XP6YCHN-PGK7KQE";};
      };
      folders = {
        "4bvms-ufujg" = {
          path = "/home/tunnel/Music/Library";
          devices = ["link" "alexandria"];
        };
        "playlists" = {
          path = "/home/tunnel/Music/Playlists";
          devices = ["link" "alexandria"];
        };
        "multimc" = {
          path = "/home/tunnel/.local/share/PrismLauncher/instances/";
          devices = ["link" "alexandria" "deck"];
        };
        "multimc-icons" = {
          path = "/home/tunnel/.local/share/PrismLauncher/icons/";
          devices = ["link" "alexandria" "deck"];
        };
        "sakft-erofr" = {
          path = "/home/tunnel/Games/ship-of-harkinian";
          devices = ["link" "alexandria" "deck"];
        };
        "singing" = {
          path = "/home/tunnel/Music/Singing";
          devices = ["link" "alexandria"];
        };
        "screenshots" = {
          path = "/home/tunnel/Pictures/Screenshots";
          devices = ["link" "alexandria"];
        };
        "qgis" = {
          path = "/home/tunnel/Documents/QGIS";
          devices = ["link" "alexandria"];
        };
        "tvhrc-cfaky" = {
          path = "/home/tunnel/.local/share/Steam/userdata/122579086/config/grid";
          devices = ["link" "deck" "alexandria"];
        };
      };
    };
  };
  networking = {
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
    hostName = "zelda";
  };
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
      fsType = "btrfs";
      options = ["subvol=@" "compress=zstd:4" "ssd" "relatime" "discard=async"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
      fsType = "btrfs";
      options = ["subvol=@home" "compress=zstd:4" "ssd" "relatime" "discard=async"];
    };
    "/home/tunnel/Music/Library" = {
      device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
      fsType = "btrfs";
      options = ["subvol=@music" "compress=zstd:4" "ssd" "relatime" "discard=async"];
    };
    "/home/tunnel/tmp" = {
      device = "none";
      fsType = "tmpfs";
      options = ["defaults" "size=2G" "mode=755"];
    };
    "/media/Data/Music" = {
      device = "/dev/disk/by-uuid/576fdcd4-d642-4229-9073-90724eb72043";
      fsType = "btrfs";
      options = ["subvol=@music" "compress=zstd:4" "ssd" "relatime" "discard=async"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/6164-2046";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics.extraPackages = with pkgs; [
      intel-media-sdk
      vaapiIntel
    ];
    nvidia = {
      open = false;
      prime = {
        sync.enable = false;
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
      };
    };
  };
}
