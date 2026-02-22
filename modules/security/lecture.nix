{
  flake.modules.nixos.base = {
    security = {
      # sudo-rs doesn't support lecture/lecture_file directives
    };
  };
}
