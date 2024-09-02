{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  # Nix Stuff
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    trusted-users = ["@wheel" "root" "nix-ssh"];
    auto-optimise-store = true;
    experimental-features = ["nix-command" "flakes"];
    substituters = [
      # high prio
      "http://link.bun-hexatonic.ts.net:8080/tunnel?priority=50"
      "https://cache.nixos.org"

      "https://helix.cachix.org"
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    trusted-substituters = ["http://link.bun-hexatonic.ts.net:8080/tunnel"];
    trusted-public-keys = [
      "tunnel:iXswb4rlkeD2EdspWLUuZwykAz1e37hmW0KBrb91OrM="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

      "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
  # User
  users.users.tunnel = {
    name = "tunnel";
    isNormalUser = true;
    home = "/home/tunnel";
    shell = pkgs.fish;
    extraGroups = ["networkmanager" "wheel" "audio" "libvirtd" "plugdev" "dialout" "video" "kvm" "libvirt" "input" "gamemode"];
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
    loader.grub = {
      enable = lib.mkDefault true;
      efiSupport = true;
      device = "nodev";
      # gfxmodeEfi = "3440x1440";
      # lib.mkForce font = true;
      # timeoutStyle = "hidden";
    };
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 600000;
      "fs.file-max" = 524288;
    };
    binfmt.emulatedSystems = ["aarch64-linux"];
  };
  # Networking
  networking.firewall.trustedInterfaces = [
    "tailscale0"
    "ztfp6fg5uh"
  ];
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];
  # System Services
  security = {
    polkit = {
      enable = true;
      extraConfig = ''
        polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.systemd1.manage-units") {
                if (action.lookup("unit") == "docker-slskd.service") {
                    var verb = action.lookup("verb");
                    if (verb == "start" || verb == "stop") {
                        return polkit.Result.YES;
                    }
                }
            }
        });
      '';
    };
    # bee sudo lecture
    sudo.configFile = ''
      Defaults lecture=always
      Defaults lecture_file = ${builtins.fetchurl {
        url = "https://gist.githubusercontent.com/willfindlay/e94cf20a8103caa762313cefa67410b5/raw/f80b4c4a376f18ff0b2475b57c6bf9a925c5fde0/sudoers.lecture";
        sha256 = "sha256:1150vava030sw9adc1fz1558a8s5mm75d2hk7wsph0sfg60mym1v";
      }}
    '';
  };
  services = {
    fail2ban.enable = true;
    openssh = {
      enable = true;
      allowSFTP = true;
      settings = {
        AllowUsers = ["tunnel"];
        PasswordAuthentication = false;
        PermitRootLogin = lib.mkForce "no";
        AllowTcpForwarding = "no";
        X11Forwarding = false;
        AllowStreamLocalForwarding = "no";
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
