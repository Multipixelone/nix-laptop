{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./snapserver.nix
    ./plexamp.nix
  ];
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  # nh default flake
  environment.variables.NH_FLAKE = "/home/tunnel/nix-laptop";

  boot = {
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    hostName = "marin";
    # useDHCP = false;
    networkmanager.enable = true;
    nameservers = ["8.8.8.8" "1.1.1.1"];
    interfaces.enp3s0f0.ipv4.addresses = [
      {
        address = "192.168.7.3";
        prefixLength = 24;
      }
    ];
    defaultGateway = {
      address = "192.168.7.1";
      interface = "enp3s0";
    };
  };
}
