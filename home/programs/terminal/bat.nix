{
  lib,
  pkgs,
  config,
  ...
}:
let
  # unpaged bat instead of cat
  bat-wrapped = pkgs.writeShellApplication {
    name = "cat";
    runtimeInputs = [
      config.programs.bat.package
    ];
    text = ''
      bat --style=header -P "$@"
    '';
  };
in
{
  programs = {
    fish.shellAliases.cat = lib.getExe bat-wrapped;
    bat = {
      enable = true;
    };
  };
}
