let
  server = [
    ./core
    ./core/boot.nix

    ./programs/theme.nix

    ./network
    ./network/tailscale.nix
  ];

  desktop =
    server
    ++ [
      ./programs
      ./programs/1password.nix
      ./programs/fonts.nix
      ./programs/hyprland
      ./programs/nix-ld.nix
      ./programs/obsidian.nix
      ./programs/xdg.nix
      ./programs/virt.nix
      ./programs/zoom.nix
      ./programs/psd.nix

      ./services/greetd.nix
      ./services/pipewire.nix
      ./services/backup.nix
      ./services/pipewire.nix

      ./network/networkman.nix
      ./network/zerotier.nix
      ./network/printing.nix

      ./hardware/g502.nix
      ./hardware/fwupd.nix
      # ./hardware/ios.nix
      ./hardware/yubikey.nix
    ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix
      ./hardware/backlight.nix
      ./hardware/power.nix

      ./network
    ];
in {
  inherit server desktop laptop;
}
