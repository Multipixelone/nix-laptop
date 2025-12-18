{ inputs, ... }:
{
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
  nixpkgs.overlays = [
    (_final: prev: {
      zjstatus = inputs.zjstatus.packages.${prev.stdenv.hostPlatform.system}.default;
    })
    (_final: prev: {
      zjstatus-hints = inputs.zjstatus-hints.packages.${prev.stdenv.hostPlatform.system}.default;
    })
    (_final: prev: {
      monocle = inputs.monocle.packages.${prev.stdenv.hostPlatform.system}.default;
    })
  ];
}
