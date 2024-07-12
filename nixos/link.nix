{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  gtfs-subway = pkgs.callPackage ../pkgs/aequilibrae/gtfs-subway.nix {};
in {
  imports = [
    ./desktop.nix
    ./modules/gamemode.nix
    ./modules/rgb.nix
    ./modules/gamestream.nix
    ./modules/attic.nix
    ./modules/minecraft-server.nix
  ];
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };
  services = {
    syncthing = {
      enable = true;
      user = "tunnel";
      configDir = "/home/tunnel/.config/syncthing";
    };
    # kmscon = {
    #   enable = true;
    #   fonts = [
    #     {
    #       name = "PragmataPro Mono Liga";
    #       package = pkgs.callPackage ../pkgs/pragmata/default.nix {};
    #     }
    #   ];
    #   extraOptions = "--term xterm-256color";
    #   extraConfig = "font-size=12";
    #   hwRender = true;
    # };
    udev.extraRules = ''
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
  };
  # TODO make this list a definition, and then make some code to turn it into the tmp file rules (can be reused in restic backup)
  systemd.tmpfiles.rules = [
    "d /srv/slskd 0770 tunnel users -"
    "d /srv/grocy 0770 tunnel users -"
    "d /srv/jdownloader 0770 tunnel users -"
    "d /srv/valhalla 0770 tunnel users -"
  ];
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      grocy = {
        image = "lscr.io/linuxserver/grocy:latest";
        autoStart = true;
        ports = ["9283:80"];
        volumes = [
          "/srv/grocy:/app"
        ];
      };
      jdownloader = {
        autoStart = true;
        image = "jlesage/jdownloader-2:latest";
        ports = ["5800:5800"];
        # user = "tunnel:users";
        # TODO find some universal way to declare these paths like my music library so that I can use a variable
        volumes = [
          "/media/Data/ImportMusic/JDownloader/:/output"
          "/srv/jdownloader/:/config"
        ];
      };
      valhalla = {
        autoStart = true;
        image = "ghcr.io/gis-ops/docker-valhalla/valhalla:latest";
        ports = ["8002:8002"];
        volumes = [
          "/srv/valhalla:/custom_files"
          # "${gtfs-subway}:/gtfs_feeds"
        ];
        environment = {
          tile_urls = "http://download.geofabrik.de/north-america/us-northeast-latest.osm.pbf";
          server_threads = "8";
          serve_tiles = "True";
          build_elevation = "True";
          build_transit = "False";
          build_admins = "True";
          build_time_zones = "True";
          build_tar = "True";
          force_rebuild = "True";
        };
      };
      slskd = {
        autoStart = true;
        image = "slskd/slskd:latest";
        ports = ["5030:5030" "2234:2234"];
        # user = "tunnel:users";
        # TODO find some universal way to declare these paths like my music library so that I can use a variable
        volumes = [
          "/srv/slskd:/app"
          "/media/Data/Music/:/music"
          "/media/Data/ImportMusic/slskd/:/downloads"
        ];
        environment = {
          # TODO add soulseek password as agenix secret
          SLSKD_REMOTE_CONFIGURATION = "true";
          SLSKD_SHARED_DIR = "/music";
          SLSKD_DOWNLOAD_DIR = "/downloads";
          SLSKD_SLSK_LISTEN_PORT = "2234";
        };
      };
    };
  };
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    i2c.enable = true;
  };
  # TODO re-enable mesa-git eventually
  chaotic.mesa-git.enable = true;
  environment.systemPackages = [
    (import ./modules/scripts/sleep.nix {inherit pkgs;})
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
  ];
  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage"];
      kernelModules = ["amdgpu"];
    };
    kernelModules = ["kvm-amd" "vfio-pci" "uinput"];
    kernelParams = [
      "video=DP-1:2560x1440@240"
      "video=DP-3:1920x1200@60"
    ];
    loader = {
      grub.useOSProber = true;
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };
  networking = {
    useDHCP = lib.mkDefault false;
    hostName = "link";
    firewall.allowedTCPPorts = [6680 8080 22 5900 6600 8384 4656 22000 47984 47989 48010 59999];
    firewall.allowedUDPPorts = [22000 21027 47998 47999 48000 48002 48010];
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
  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
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
  swapDevices = [{device = "/swap/swapfile";}];
  fileSystems = {
    "/boot/efi" = {device = "/dev/disk/by-uuid/9433-A195";};
    "/swap" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
      options = ["subvol=@swap"];
    };
    "/" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
      options = ["subvol=/@nixos" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache"];
    };
    "/home" = {
      device = "/dev/disk/by-label/Linux";
      fsType = "btrfs";
      options = ["subvol=/@home" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache"];
    };
    #"/media/Arch" =
    #  { device = "/dev/disk/by-label/SlowData";
    #    fsType = "btrfs";
    #    options = [ "subvol=/@Arch" "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag" ];
    #  };
    "/media/TeraData" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@games" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/media/Data" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@data" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/home/tunnel/Games/ROMs" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@roms" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/volume1/Media" = {
      device = "/dev/disk/by-label/TeraData";
      fsType = "btrfs";
      options = ["subvol=/@data" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/media/BigData" = {
      device = "/dev/disk/by-label/BigData";
      fsType = "btrfs";
      options = ["subvol=/" "compress=zstd:3" "relatime" "ssd" "discard=async" "space_cache=v2"];
    };
    "/media/SlowData" = {
      device = "/dev/disk/by-label/SlowData";
      fsType = "btrfs";
      options = ["subvol=/" "compress=zstd:3" "noatime" "space_cache=v2" "autodefrag"];
    };
    "/media/Windows" = {
      device = "/dev/disk/by-label/Windows";
      fsType = "ntfs";
      options = ["nosuid" "nodev" "relatime" "blksize=4096"];
    };
  };
}
