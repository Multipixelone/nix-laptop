{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  hardware.enableRedistributableFirmware = true;
  # Nix Stuff
  age.secrets = {
    "attic".file = "${inputs.secrets}/attic.age";
    "wireguard".file = "${inputs.secrets}/wireguard/${config.networking.hostName}.age";
    "psk".file = "${inputs.secrets}/wireguard/psk.age";
    "duckdns".file = "${inputs.secrets}/wireguard/duckdns.age";
    "nix" = {
      file = "${inputs.secrets}/github/nix.age";
      mode = "440";
      owner = "tunnel";
      group = "users";
    };
  };
  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      !include ${config.age.secrets.nix.path}
    '';
    settings = {
      trusted-users = ["@wheel" "root" "nix-ssh"];
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        # lowest priority (hit my cache last)
        "https://attic-cache.fly.dev/system?priority=50"
        "https://cache.nixos.org"

        "https://helix.cachix.org"
        "https://anyrun.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];
      trusted-public-keys = [
        "system:XwpCBI5UHFzt9tEmiq3v8S062HvTqWPUwBR8PoHSfSk="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="

        "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
      netrc-file = config.age.secrets."attic".path;
    };
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
    "wg0"
  ];
  systemd.services.NetworkManager-wait-online.enable = false;
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port 51628];
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

      # Logitech G502 Lightspeed
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TEST=="power/control", ATTR{power/control}="on"
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TEST=="power/autosuspend", ATTR{power/autosuspend}="0"
      SUBSYSTEM=="usb", ATTR{idVendor}=="046d", ATTR{idProduct}=="c539", TEST=="power/autosuspend_delay_ms", ATTR{power/autosuspend_delay_ms}="0"
    '';
    tailscale.enable = true;
  };
  # Programs
  programs = {
    command-not-found.enable = false;
    ssh.startAgent = true;
    fish.enable = true;
    mosh.enable = true;
    appimage.binfmt = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/tunnel/Documents/Git/nix-laptop";
    };
  };
  system.stateVersion = "23.11";
}
