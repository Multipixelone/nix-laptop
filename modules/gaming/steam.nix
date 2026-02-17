{
  nixpkgs.config.allowUnfreePackages = [
    "steam"
    "steam-unwrapped"
  ];
  flake.modules.nixos.gaming = {
    programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
