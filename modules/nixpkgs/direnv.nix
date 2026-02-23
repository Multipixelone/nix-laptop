{
  flake.modules.nixos.base = {
    nix.settings = {
      # for direnv GC roots
      keep-derivations = true;
      keep-outputs = true;
    };
  };
}
