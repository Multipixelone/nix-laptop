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
