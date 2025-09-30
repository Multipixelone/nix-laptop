{
  lib,
  pkgs,
  ...
}:
let
  ovCommand = lib.getExe pkgs.ov;
in
{
  programs = {
    fish.functions.__fish_anypager = "echo ${ovCommand}";
  };
  home = {
    sessionVariables = {
      PAGER = ovCommand;
      MANPAGER = "${ovCommand} --section-delimiter '^[^\\s]' --section-header";
      BAT_PAGER = "${ovCommand} --quit-if-one-screen --header 3";
    };
    packages = with pkgs; [
      delta
      ov
    ];
  };
}
