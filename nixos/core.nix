{
  config,
  pkgs,
  lib,
  inputs,
  stylix,
  ...
}: {
  imports = [
    ./modules/greetd.nix
    ./modules/backup.nix
  ];
  hardware.enableRedistributableFirmware = true;
  environment.systemPackages = with pkgs; [
    vim
    git
    tailscale
    virt-manager
    qemu_kvm
    qemu
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
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
    inputs.agenix.packages.${pkgs.system}.default
    #inputs.packages.${pkgs.system}.qtscrob
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
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
  stylix.image = builtins.fetchurl {
    url = "https://drive.usercontent.google.com/download?id=1OrRpU17DU78sIh--SNOVI6sl4BxE06Zi";
    sha256 = "sha256:14nh77xn8x58693y2na5askm6612xqbll2kr6237y8pjr1jc24xp";
  };
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
  networking.firewall.trustedInterfaces = ["tailscale0"];
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
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
  services.printing.enable = true;
  services.avahi.publish.userServices = true;
  # Programs
  programs.command-not-found.enable = false;
  programs.ssh.startAgent = true;
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.mosh.enable = true;
  programs.wireshark.enable = true;
  programs.nix-ld.enable = true;
  programs.nm-applet.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/tunnel/Documents/Git/nix-laptop";
  };
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
