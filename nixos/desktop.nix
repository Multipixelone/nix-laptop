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
    inputs.nix-gaming.nixosModules.pipewireLowLatency
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_kvm
    qemu
    # TODO fix latency flex
    # inputs.chaotic.packages.${pkgs.system}.latencyflex-vulkan
    xdg-utils
    appimage-run
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
    pulseaudioFull
    (inputs.geospatial.packages.${pkgs.system}.qgis.override {
      extraPythonPackages = ps: [ps.pandas ps.numpy ps.scipy ps.pandas ps.charset-normalizer ps.click-plugins ps.click ps.certifi ps.cligj ps.colorama ps.fiona ps.pyproj ps.pytz ps.requests ps.rtree ps.setuptools ps.shapely ps.six ps.tzdata ps.zipp ps.attrs ps.dateutil ps.python-dateutil ps.idna ps.importlib-metadata ps.pyaml ps.urllib3 ps.packaging ps.cython ps.ortools ps.numexpr ps.py-cpuinfo ps.tables ps.fastparquet];
    })
    # TODO (inputs.nixpkgs-stable.legacyPackages.${pkgs.system}.pkgs.callPackage ../pkgs/aequilibrae/default.nix {inherit inputs;})
    inputs.geospatial.packages.${pkgs.system}.libspatialite
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  stylix = {
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    image = builtins.fetchurl {
      url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
      sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
    };
    fonts = {
      serif = {
        name = "PragmataPro Liga";
        package = pkgs.callPackage ../pkgs/pragmata/default.nix {};
      };
      sansSerif = {
        name = "PragmataPro Liga";
        package = pkgs.callPackage ../pkgs/pragmata/default.nix {};
      };
      monospace = {
        name = "PragmataPro Mono Liga";
        package = pkgs.callPackage ../pkgs/pragmata/default.nix {};
      };
      emoji = {
        name = "AppleColorEmoji";
        package = pkgs.callPackage ../pkgs/apple-fonts/default.nix {};
      };
    };
  };
  boot = {
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = ["quiet" "splash" "rd.systemd.show_status=false" "rd.udev.log_level=3" "udev.log_priority=3" "boot.shell_on_fail"];
    # xanmod or zen
    # kernelPackages = pkgs.linuxPackages_xanmod;
    kernelPackages = pkgs.linuxPackages_zen;
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    brillo.enable = true;
  };
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = ["52b337794f640fc8"];
    };
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
    ratbagd.enable = true; # Logitech mouse daemon
    geoclue2.enable = true;
    localtimed.enable = true;
    psd.enable = true;
    printing.enable = true;
    blueman.enable = true;
  };
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = false;
      platformOptimizations.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    wireshark.enable = true;
    nm-applet.enable = true;
    hyprland.enable = true;
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

    "text/html" = "firefox-beta.desktop";
    "default-web-browser" = "firefox-beta.desktop";
    "x-scheme-handler/http" = "firefox-beta.desktop";
    "x-scheme-handler/https" = "firefox-beta.desktop";
    "x-scheme-handler/about" = "firefox-beta.desktop";
    "x-scheme-handler/unknown" = "firefox-beta.desktop";

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
  };
  # Required for Obsidian
  nixpkgs = {
    config.permittedInsecurePackages = [
      "electron-25.9.0"
      "electron-28.2.10"
    ];
    overlays = [inputs.nur.overlay];
  };
  # Fonts
  fonts.packages = with pkgs; [
    ipafont
  ];
  fonts = {
    fontconfig = {
      defaultFonts = {
        # ipa gothic required for cjk support
        serif = ["PragmataPro Liga" "IPAGothic"];
        sansSerif = ["PragmataPro Liga" "IPAGothic"];
        monospace = ["PragmataPro Mono Liga" "IPAGothic"];
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
