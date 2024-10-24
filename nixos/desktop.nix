{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./core.nix
    ./modules/greetd.nix
    ./modules/backup.nix
    ./modules/security.nix
    ./modules/media.nix
    ./modules/nix-ld.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
    inputs.catppuccin.nixosModules.catppuccin
  ];
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    age-plugin-yubikey
    qemu_kvm
    qemu
    # TODO fix latency flex
    # inputs.chaotic.packages.${pkgs.system}.latencyflex-vulkan
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    inputs.nix-gaming.packages.${pkgs.system}.winetricks-git
    xdg-utils
    pyprland
    libsmbios
    papirus-icon-theme
    papirus-folders
    arc-theme
    libsForQt5.kio
    libsForQt5.kio-extras
    inputs.agenix.packages.${pkgs.system}.default
    (libsForQt5.callPackage ../pkgs/qtscrob/default.nix {})
    (callPackage ../pkgs/spotify2musicbrainz/default.nix {})
    inputs.khinsider.packages.${pkgs.system}.default
    pulseaudioFull
    (inputs.geospatial.packages.${pkgs.system}.qgis.override {
      extraPythonPackages = ps: [
        ps.protobuf
        ps.pyarrow
        ps.ortools
        ps.absl-py
        ps.immutabledict
      ];
    })
    # (inputs.geospatial.packages.${pkgs.system}.qgis.override {
    #   extraPythonPackages = ps: [ps.pandas ps.numpy ps.scipy ps.pandas ps.charset-normalizer ps.click-plugins ps.click ps.certifi ps.cligj ps.colorama ps.fiona ps.pyproj ps.pytz ps.requests ps.rtree ps.setuptools ps.shapely ps.six ps.tzdata ps.zipp ps.attrs ps.dateutil ps.python-dateutil ps.idna ps.importlib-metadata ps.pyaml ps.urllib3 ps.packaging ps.cython ps.ortools ps.numexpr ps.py-cpuinfo ps.tables ps.fastparquet];
    # })
    # TODO (inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pkgs.callPackage ../pkgs/aequilibrae/default.nix {inherit inputs;})
    # inputs.geospatial.packages.${pkgs.system}.libspatialite
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    image = builtins.fetchurl {
      url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
      sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
    };
  };
  # testing different schedulers
  # chaotic.scx = {
  #   enable = true;
  #   scheduler = "scx_lavd";
  #   # scheduler = "scx_rustland";
  # };
  boot = {
    plymouth = {
      enable = false;
      catppuccin.enable = false;
      theme = "nixos-bgrt";
      themePackages = with pkgs; [
        nixos-bgrt-plymouth
      ];
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
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      disabledPlugins = ["sap"];
      settings = {
        General = {
          FastConnectable = "true";
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    brillo.enable = true;
    graphics = {
      # 32 bit support
      enable32Bit = true;
    };
  };
  networking.nameservers = ["127.0.0.1" "::1"];
  services = {
    blueman.enable = true;
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    fwupd.enable = true;
    ratbagd.enable = true; # Logitech mouse daemon
    geoclue2.enable = true;
    psd.enable = true;
    btrfs.autoScrub.enable = true;
    printing.enable = true;
    dnscrypt-proxy2 = {
      enable = true;
      settings = {
        listen_addresses = ["0.0.0.0:53"];
        ipv6_servers = true;
        require_dnssec = true;
        blocked_names.blocked_names_file = "${inputs.blocklist}/hosts";
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
    zerotierone = {
      enable = true;
      joinNetworks = ["52b337794f640fc8"];
    };
    udev.packages = with pkgs; [
      yubikey-personalization
      libu2f-host
    ];
  };
  programs = {
    wireshark.enable = true;
    nm-applet.enable = true;
    virt-manager.enable = true;
    _1password-gui.enable = true;
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprportal.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };
  };
  # Wayland Stuff
  xdg = {
    portal = {
      enable = true;
      wlr.enable = false;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
    };
  };
  xdg.mime.defaultApplications = {
    "inode/directory" = "nemo.desktop";

    "text/html" = "firefox.desktop";
    "default-web-browser" = "firefox.desktop";
    "x-scheme-handler/http" = "firefox.desktop";
    "x-scheme-handler/https" = "firefox.desktop";
    "x-scheme-handler/about" = "firefox.desktop";
    "x-scheme-handler/unknown" = "firefox.desktop";

    "application/pdf" = "org.pwmt.zathura.desktop";
    "application/zip" = "ark.desktop";

    "audio/flac" = "vlc.desktop";
    "audio/x-flac" = "vlc.desktop";

    "audio/wav" = "izotope-rx-10.desktop";
    "audio/x-wav" = "izotope-rx-10.desktop";
  };
  # Audio + Music
  musnix.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    lowLatency.enable = true;
    wireplumber.enable = true;
  };
  # Required for Obsidian
  nixpkgs = {
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-28.2.10"
    ];
    overlays = [
      inputs.nur.overlay
      (_final: prev: {
        zjstatus = inputs.zjstatus.packages.${prev.system}.default;
      })
      # TODO remove this once (https://github.com/nix-community/home-manager/issues/5991)
      (self: super: {utillinux = super.util-linux;})
      # TODO remove this once cliphist hits unstable (see https://github.com/NixOS/nixpkgs/pull/348887)
      (final: prev: {
        cliphist = prev.cliphist.overrideAttrs (_old: {
          src = final.fetchFromGitHub {
            owner = "sentriz";
            repo = "cliphist";
            rev = "c49dcd26168f704324d90d23b9381f39c30572bd";
            sha256 = "sha256-2mn55DeF8Yxq5jwQAjAcvZAwAg+pZ4BkEitP6S2N0HY=";
          };
          vendorHash = "sha256-M5n7/QWQ5POWE4hSCMa0+GOVhEDCOILYqkSYIGoy/l0=";
        });
      })
    ];
  };
  # Fonts
  fonts = {
    enableDefaultPackages = false;
    packages = with pkgs; [
      ipafont
      minecraftia
      corefonts
      vistafonts
      inputs.apple-fonts.packages.${pkgs.system}.ny
      inputs.apple-fonts.packages.${pkgs.system}.sf-pro
      inputs.apple-fonts.packages.${pkgs.system}.sf-compact
      inputs.apple-fonts.packages.${pkgs.system}.sf-mono
      (nerdfonts.override {fonts = ["Iosevka"];})
      (pkgs.callPackage ../pkgs/pragmata/default.nix {})
      (pkgs.callPackage ../pkgs/apple-fonts/default.nix {})
    ];
    fontconfig = {
      defaultFonts = {
        # ipa gothic required for cjk support
        serif = ["PragmataPro Liga" "IPAGothic"];
        sansSerif = ["PragmataPro Liga" "IPAGothic"];
        monospace = ["PragmataPro Mono Liga" "IPAGothic"];
        emoji = ["Apple Color Emoji"];
      };
    };
  };
  # Virt
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };
    waydroid.enable = true;
    lxd.enable = true;
    # FIX figure out why rootless podman isn't working. Replace with docker for now
    podman = {
      enable = false;
      # dockerCompat = false;
      # autoPrune.enable = true;
      # defaultNetwork.settings.dns_enabled = true;
    };
    docker = {
      storageDriver = "btrfs";
      autoPrune.enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
      daemon.settings = {
        dns = ["1.1.1.1"];
      };
    };
    vmVariant = {
      virtualisation = {
        memorySize = 4096;
        cores = 3;
        graphics = false;
      };
    };
  };
}
