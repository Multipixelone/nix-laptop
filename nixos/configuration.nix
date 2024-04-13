{
  config,
  pkgs,
  lib,
  inputs,
  stylix,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./greetd.nix
  ];
  environment.systemPackages = with pkgs; [
    vim
    git
    tailscale
    virt-manager
    qemu_kvm
    qemu
    #inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    wineWowPackages.waylandFull
    xdg-utils
    greetd.greetd
    appimage-run
    pyprland
    xcb-util-cursor
    libsmbios
    papirus-icon-theme
    papirus-folders
    arc-theme
    libsForQt5.kio
    libsForQt5.kio-extras
    brightnessctl
    (import ./scripts/ipod.nix {inherit pkgs;})
    #inputs.packages.${pkgs.system}.qtscrob
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # Automatic Upgrade
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L" # print build logs
    ];
    dates = "12:00";
    randomizedDelaySec = "45min";
  };
  # Nix Stuff
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    substituters = ["https://hyprland.cachix.org" "https://nix-community.cachix.org" "https://nix-gaming.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  # User
  users.users.tunnel = {
    name = "tunnel";
    isNormalUser = true;
    home = "/home/tunnel";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "audio" "libvirtd" "plugdev" "dialout" "video" "kvm" "libvirt" "input"];
  };
  time.timeZone = "America/New_York";
  # Theme
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.polarity = "dark";
  stylix.image = ./SU_NY.JPG;
  stylix = {
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
    };
  };
  # Boot
  boot.plymouth.enable = true;
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi = {
    efiSysMountPoint = "/boot";
    canTouchEfiVariables = true;
  };
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    #gfxmodeEfi = "3440x1440";
    #lib.mkForce font = true;
    font = lib.mkForce "${pkgs.callPackage ../pkgs/pragmata/default.nix {}}/share/fonts/truetype/PragmataPro_Bold_0827.ttf";
    fontSize = 60;
    #timeoutStyle = "hidden";
  };
  boot.kernel.sysctl = {
    "vm.max_map_count" = 2147483642;
    "fs.inotify.max_user_watches" = 600000;
  };
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
  # Networking
  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = ["tailscale0"];
  networking.hostName = "zelda";
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.allowedTCPPorts = [22 5900 8384 22000 47984 47989 48010 59999];
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port 22000 21027 47998 47999 48000 48002 48010];
  # System Services
  security.polkit.enable = true;
  services.flatpak.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;
  services.psd.enable = true;
  services.udisks2.enable = true;
  services.avahi.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.xserver.enable = false;
  services.xserver.displayManager.sddm.enable = false;
  services.xserver.displayManager.sddm.wayland.enable = false;
  services.printing.enable = true;
  # Programs
  programs.command-not-found.enable = false;
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.mosh.enable = true;
  programs.nm-applet.enable = true;
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
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
  # Laptop Stuff
  services.tlp = {
    enable = false;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 40;
    };
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
          devices = ["link" "alexandria" "deck"];
        };
      };
    };
  };
  # Fonts
  fonts = {
    fontconfig = {
      defaultFonts = {
        serif = ["PragmataPro Liga"];
        sansSerif = ["PragmataPro Liga"];
        monospace = ["PragmataPro Mono Liga"];
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
  system.stateVersion = "23.11";
}
