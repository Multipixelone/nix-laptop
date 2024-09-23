{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ./desktop.nix
    inputs.nix-hardware.nixosModules.dell-xps-15-9560-intel
    inputs.auto-cpufreq.nixosModules.default
  ];
  # specialisation = {
  #   nvidia-sync.configuration = {
  #     imports = [
  #       inputs.nix-hardware.nixosModules.dell-xps-15-9560-nvidia
  #     ];
  #     hardware.nvidia = {
  #       open = false;
  #       prime = {
  #         sync.enable = lib.mkForce true;
  #         offload = {
  #           enable = lib.mkForce false;
  #           enableOffloadCmd = lib.mkForce false;
  #         };
  #       };
  #     };
  #   };
  # };
  boot = {
    # use ram for /tmp
    tmp = {
      useTmpfs = true;
      tmpfsSize = "30%";
    };
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
  programs.auto-cpufreq = {
    enable = true;
    settings = {
      charger = {
        governor = "performance";
        turbo = "auto";
      };
      battery = {
        governor = "powersave";
        turbo = "auto";
      };
    };
  };
  services = {
    thermald.enable = true;
    tlp.enable = false;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        ipv6_servers = true;
        require_dnssec = true;
        sources.public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
        };
      };
    };
    # # testing undervolting
    # undervolt = {
    #   enable = true;
    #   # analogioOffset = -10;
    #   coreOffset = -10;
    #   # gpuOffset = -10;
    # };
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
    nameservers = ["127.0.0.1" "::1"];
    networkmanager = {
      enable = true;
      dns = "none";
    };
    useDHCP = lib.mkDefault true;
    hostName = "zelda";
    wireguard.interfaces.wg0 = {
      ips = ["10.100.0.2/24"];
      listenPort = 51628;
      privateKeyFile = config.age.secrets."wireguard".path;
      peers = [
        {
          publicKey = "i2nI/xG1Jh3WVyOk79Lz/jH6B9SbmnocjbZv+fLoJwE=";
          allowedIPs = ["0.0.0.0/0"];
          endpoint = "frwgq.duckdns.org:51628";
          persistentKeepalive = 25;
        }
      ];
    };
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
      options = ["defaults" "size=2G" "mode=755" "noatime" "nosuid" "nodev" "noexec" "mode=1777"];
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
      # intel-media-sdk
      intel-media-driver
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
