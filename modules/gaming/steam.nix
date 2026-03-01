{ inputs, ... }:
{
  nixpkgs.config = {
    allowUnfreePackages = [
      "steam"
      "steam-unwrapped"
    ];
    packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraProfile = ''
          # Fixes timezones
          unset TZ
          # Allows Monado to be used
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        '';
        extraPkgs =
          pkgs: with pkgs; [
            libXcursor
            libXi
            libXinerama
            libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
            # Steam VR
            procps
            usbutils
          ];
      };
    };
  };
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
