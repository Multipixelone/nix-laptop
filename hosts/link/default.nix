{
  pkgs,
  self,
  inputs,
  ...
}: {
  imports = [
    inputs.ucodenix.nixosModules.default
    ./hardware-configuration.nix
    ./hyprland.nix
    ./valhalla.nix
  ];

  boot = {
    initrd.kernelModules = ["amdgpu"];
    kernelModules = ["kvm-amd" "vfio-pci" "uinput"];
    kernelParams = [
      "amd_pstate=active"
    ];
  };

  # hint epp to use maximum cpu performance
  powerManagement.cpuFreqGovernor = "performance";

  # nh default flake
  environment.variables.FLAKE = "/home/tunnel/Documents/Git/nix-laptop";

  # fan control
  systemd = {
    packages = with pkgs; [lact];
    services.lactd.wantedBy = ["multi-user.target"];
  };

  # console readability
  console = {
    earlySetup = true;
    font = "${pkgs.terminus_font}/share/consolefonts/ter-132n.psf.gz";
    packages = with pkgs; [terminus_font];
    keyMap = "us";
  };

  # network address & hostname
  networking = {
    hostName = "link";
    interfaces.enp6s0.ipv4.addresses = [
      {
        address = "192.168.6.6";
        prefixLength = 24;
      }
    ];
    interfaces.enp6s0.useDHCP = false;
    defaultGateway = "192.168.6.1";
  };

  security.tpm2.enable = true;

  services = {
    fstrim.enable = true;
    btrfs.autoScrub.enable = true;
    syncthing = {
      enable = true;
      user = "tunnel";
      configDir = "/home/tunnel/.config/syncthing";
    };
  };
}
