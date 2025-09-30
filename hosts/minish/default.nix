{ inputs, ... }:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];
  # nh default flake
  environment.variables.NH_FLAKE = "/home/tunnel/Documents/Git/nix-laptop";

  # media env vars
  environment.variables = {
    MUSIC_DIR = "C:\\Users\\Finn Rutis\\Music\\Library";
    PLAYLIST_DIR = "/mnt/c/Users/Finn Rutis/Music/Playlists";
  };

  networking.hostName = "minish";
  wsl = {
    enable = true;
    defaultUser = "tunnel";
    interop.register = true;
    startMenuLaunchers = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
