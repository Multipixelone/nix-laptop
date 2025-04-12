let
  server = [
    ./core
    ./core/boot.nix

    ./network
    ./network/tailscale.nix
  ];

  desktop =
    server
    ++ [
      ./programs
      ./programs/hyprland
      ./programs/theme.nix

      ./services/greetd.nix
      ./services/pipewire.nix

      ./network/networkman.nix
      ./network/zerotier.nix

      ./hardware/g502.nix
    ];

  laptop =
    desktop
    ++ [
      ./hardware/bluetooth.nix

      ./services/backlight.nix
    ];
in {
  inherit server desktop laptop;
}
