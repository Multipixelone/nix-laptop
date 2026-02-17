{
  flake.modules.nixos.base = {
    programs.fish.enable = true;
    programs.command-not-found.enable = false;
  };
}
