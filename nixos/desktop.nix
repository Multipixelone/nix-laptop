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
  ];
  environment.systemPackages = with pkgs; [
    virt-manager
    qemu_kvm
    qemu
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    inputs.chaotic.packages.${pkgs.system}.latencyflex-vulkan
    xdg-utils
    appimage-run
    pyprland
    libsmbios
    papirus-icon-theme
    papirus-folders
    arc-theme
    libsForQt5.kio
    libsForQt5.kio-extras
    brightnessctl
    inputs.agenix.packages.${pkgs.system}.default
    (pkgs.libsForQt5.callPackage ../pkgs/qtscrob/default.nix {})
    (yabridge.override {
      wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
    })
    yabridgectl
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
    kernelPackages = pkgs.linuxPackages_cachyos;
  };
  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
  };
  services = {
    zerotierone = {
      enable = true;
      joinNetworks = ["52b337794f640fc8"];
    };
    flatpak.enable = true;
    gnome.gnome-keyring.enable = true;
    psd.enable = true;
    printing.enable = true;
  };
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };
    wireshark.enable = true;
    nm-applet.enable = true;
    hyprland = {
      enable = true;
    };
  };
  # Wayland Stuff
  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
  xdg.mime.defaultApplications = {
    "x-scheme-handler/http" = "firefox";
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
  };
  # Required for Obsidian
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-28.2.10"
  ];
  # Fonts
  fonts.packages = with pkgs; [
    ipafont
  ];
  fonts = {
    fontconfig = {
      defaultFonts = {
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
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
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
