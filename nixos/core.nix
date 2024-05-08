{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  # Nix Stuff
  nixpkgs = {
    config.allowUnfree = true;
    #  buildPlatform.system = "x86_64-linux";
    #  hostPlatform.system = "aarch64-linux";
  };
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings = {
    trusted-users = ["@wheel" "root" "nix-ssh"];
    auto-optimise-store = true;
    substituters = ["http://link.bun-hexatonic.ts.net:8080/tunnel" "https://hyprland.cachix.org" "https://nix-community.cachix.org" "https://nix-gaming.cachix.org"];
    trusted-substituters = ["http://link.bun-hexatonic.ts.net:8080/tunnel"];
    trusted-public-keys = ["tunnel:iXswb4rlkeD2EdspWLUuZwykAz1e37hmW0KBrb91OrM=" "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="];
  };
  # User
  users.users.tunnel = {
    name = "tunnel";
    isNormalUser = true;
    home = "/home/tunnel";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "audio" "libvirtd" "plugdev" "dialout" "video" "kvm" "libvirt" "input"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfFq+1W21NoXAyFc1HT5zJ7GAVDbQw/f6reJI3X2vtn link"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5bqb1RiYN2X5dx4GKlTgeiWhYWHQhiV/HU1MtOZfFt zelda"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBK7HXtVv6LFt7sH5QUrj80iqtaUmYJuf7eBwmsdzni7epBfrX2iyZzzXtIDSdgPaOhSJp5FJIkBvA6UMMkveYbM= iphone"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBGm2epY8mE3z7qoL10fXmBuv4EPHnQoqJoYrL9TgfJwhnZMsaf1FQ2jalGSCE6T+QuYF/WM+bIWxZiYrT/XisM= ipad"
    ];
  };
  time.timeZone = "America/New_York";
  # Theme
  # Boot
  boot = {
    loader.systemd-boot.enable = false;
    loader.grub = {
      enable = lib.mkDefault true;
      efiSupport = true;
      device = "nodev";
      #gfxmodeEfi = "3440x1440";
      #lib.mkForce font = true;
      #timeoutStyle = "hidden";
    };
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "fs.inotify.max_user_watches" = 600000;
    };
    binfmt.emulatedSystems = ["aarch64-linux"];
  };
  # Networking
  networking.firewall.trustedInterfaces = ["tailscale0"];
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
  # System Services
  security.polkit.enable = true;
  services = {
    openssh = {
      enable = true;
      settings = {
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkForce "no";
      };
    };
    tailscale.enable = true;
  };
  # Programs
  programs = {
    command-not-found.enable = false;
    ssh.startAgent = true;
    fish.enable = true;
    mosh.enable = true;
    nix-ld.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/tunnel/Documents/Git/nix-laptop";
    };
  };
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
  system.stateVersion = "23.11";
}
