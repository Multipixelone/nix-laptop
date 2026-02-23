{ inputs, ... }:
{
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
  flake.modules.nixos.gaming =
    { pkgs, ... }:
    {
      imports = [
        inputs.nix-gaming.nixosModules.platformOptimizations
      ];
      hardware = {
        steam-hardware.enable = true;
        graphics = {
          # 32 bit support
          enable32Bit = true;
        };
      };

      programs.steam = {
        enable = true;
        localNetworkGameTransfers.openFirewall = true;
        platformOptimizations.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];

      };
    };
}
