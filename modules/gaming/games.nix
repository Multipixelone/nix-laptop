{
  nixpkgs.config.allowUnfreePackages = [
    "vintagestory"
  ];
  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.prismlauncher
        pkgs.vintagestory
      ];
    };
}
