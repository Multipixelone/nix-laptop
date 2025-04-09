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
    ./modules/minecraft-server.nix
    inputs.ucodenix.nixosModules.default
  ];
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };
  users.users.cloudflared = {
    group = "cloudflared";
    isSystemUser = true;
  };
  users.groups.cloudflared = {};
  services = {
    ucodenix = {
      enable = config.hardware.enableRedistributableFirmware;
      cpuModelId = "00A20F10";
    };
    syncthing = {
      enable = true;
      user = "tunnel";
      configDir = "/home/tunnel/.config/syncthing";
    };
    printing = {
      drivers = [
        # add drivers for Canon MG3222
        pkgs.gutenprint
        pkgs.gutenprintBin
      ];
      browsing = true;
      defaultShared = true;
      listenAddresses = ["*:631"];
      allowFrom = ["all"];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };
  };
  # TODO make this list a definition, and then make some code to turn it into the tmp file rules (can be reused in restic backup)
  systemd = {
    packages = with pkgs; [lact];
    services.lactd.wantedBy = ["multi-user.target"];
    services.cf-tunnel = {
      wantedBy = ["multi-user.target"];
      after = ["network-online.target" "dnscrypt-proxy2.service"];
      serviceConfig = {
        # this is gross
        ExecStart = ''
          ${lib.getExe pkgs.bash} -c "${lib.getExe inputs.nixpkgs-cloudflared.legacyPackages.${pkgs.system}.cloudflared} tunnel --no-autoupdate run --token $(${lib.getExe' pkgs.coreutils "cat"} ${config.age.secrets."cf".path})"'';
        Restart = "always";
        User = "cloudflared";
        Group = "cloudflared";
      };
    };
    tmpfiles.rules = let
      # create env for rocm override
      # rocmEnv = pkgs.symlinkJoin {
      #   name = "rocm-combined";
      #   paths = with pkgs.rocmPackages; [
      #     rocblas
      #     hipblas
      #     clr
      #   ];
      # };
    in [
      "d /srv/slskd 0770 tunnel users -"
      "d /srv/grocy 0770 tunnel users -"
      "d /srv/jdownloader 0770 tunnel users -"
      "d /srv/valhalla 0770 tunnel users -"
      # "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
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
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      grocy = {
        image = "lscr.io/linuxserver/grocy:latest";
        autoStart = false;
        ports = ["9283:80"];
        volumes = [
          "/srv/grocy:/app"
        ];
      };
      jdownloader = {
        autoStart = false;
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
        autoStart = false;
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
          build_transit = "True";
          build_admins = "True";
          build_time_zones = "True";
          build_tar = "True";
          force_rebuild = "False";
        };
      };
      slskd = {
        autoStart = true;
        image = "slskd/slskd:canary";
        ports = ["5030:5030" "2234:2234"];
        user = "1000:100";
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
  # hint epp to use maximum cpu performance
  powerManagement.cpuFreqGovernor = "performance";
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    i2c.enable = true;
    steam-hardware.enable = true;
    printers = {
      ensurePrinters = [
        {
          name = "Canon_MG3222";
          location = "Office";
          deviceUri = "usb://Canon/MG3200%20series?serial=3131AC&interface=1";
          model = "gutenprint.${lib.versions.majorMinor (lib.getVersion pkgs.gutenprint)}://bjc-PIXMA-MG3222/expert";
          description = "Office Printer";
        }
      ];
      ensureDefaultPrinter = "Canon_MG3222";
    };
  };
  # TODO re-enable mesa-git eventually
  chaotic = {
    mesa-git.enable = false;
    duckdns = {
      enable = true;
      domain = "frwgq.duckdns.org";
      environmentFile = config.age.secrets."duckdns".path;
    };
  };
  environment.systemPackages = [
    pkgs.lact
    (import ./modules/scripts/sleep.nix {inherit pkgs;})
    # (pkgs.blender.override {hipSupport = true;})
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
      "amd_pstate=active"
    ];
    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
        canTouchEfiVariables = true;
      };
    };
  };
  networking = {
    useDHCP = lib.mkDefault false;
    hostName = "link";
    firewall.allowedTCPPorts = [53 631 5353 6680 8080 22 5900 6600 8384 4656 22000 47984 47989 48010 59999];
    firewall.allowedUDPPorts = [443 631 5353 22000 21027 47998 47999 48000 48002 48010];
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
    nat = {
      enable = true;
      externalInterface = "enp6s0";
      internalInterfaces = ["wg0"];
    };
    wireguard.interfaces = {
      wg0 = {
        ips = ["10.100.0.1/24"];
        listenPort = 443;
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp6s0 -j MASQUERADE
        '';
        privateKeyFile = config.age.secrets."wireguard".path;
        peers = [
          {
            # zelda
            publicKey = "8mNNHB03ytgnnZMPv0AZOpgZVumEvy3tr+E7h3WBCUI=";
            presharedKeyFile = config.age.secrets."psk".path;
            allowedIPs = ["10.100.0.2/32"];
          }
          {
            # nougat
            publicKey = "CgAqN+0T70Exkduy1j0IyOHThHSSIPUmFPzdupLXUUk=";
            allowedIPs = ["10.100.0.50/32"];
          }
        ];
      };
    };
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
    # "/media/Windows" = {
    #   device = "/dev/disk/by-label/Windows";
    #   fsType = "ntfs";
    #   options = ["nosuid" "nodev" "relatime" "blksize=4096"];
    # };
  };
}
