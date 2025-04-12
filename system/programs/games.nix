{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.nix-gaming.nixosModules.platformOptimizations
  ];
  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 600000;
    "fs.file-max" = 524288;
  };
  hardware = {
    graphics = {
      # 32 bit support
      enable32Bit = true;
    };
  };
  nixpkgs = {
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
