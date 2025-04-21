{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 600000;
    "fs.file-max" = 524288;
  };
  chaotic.mesa-git.enable = true;
  hardware = {
    graphics = {
      # 32 bit support
      enable32Bit = true;
    };
  };
  environment.systemPackages = with pkgs; [
    inputs.nix-gaming.packages.${pkgs.system}.wine-tkg
    inputs.nix-gaming.packages.${pkgs.system}.winetricks-git
    inputs.humble-key.packages.${pkgs.system}.default
  ];
  nixpkgs = {
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
      ];
    config.packageOverrides = pkgs: {
      steam = pkgs.steam.override {
        extraPkgs = pkgs:
          with pkgs; [
            xorg.libXcursor
            xorg.libXi
            xorg.libXinerama
            xorg.libXScrnSaver
            libpng
            libpulseaudio
            libvorbis
            stdenv.cc.cc.lib
            libkrb5
            keyutils
          ];
      };
    };
  };
  programs.steam = {
    enable = true;
    gamescopeSession.enable = false;
    platformOptimizations.enable = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };
}
