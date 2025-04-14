{inputs, ...}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  # nh default flake
  environment.variables.FLAKE = "/home/tunnel/Documents/Git/nix-laptop";

  networking.hostName = "minish";
  wsl = {
    enable = true;
    defaultUser = "tunnel";
    interop.register = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
