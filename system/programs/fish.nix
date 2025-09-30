{inputs, ...}: {
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
  nixpkgs.overlays = [
    (_final: prev: {
      zjstatus = inputs.zjstatus.packages.${prev.system}.default;
    })
    (_final: prev: {
      zjstatus-hints = inputs.zjstatus-hints.packages.${prev.system}.default;
    })
    (_final: prev: {
      monocle = inputs.monocle.packages.${prev.system}.default;
    })
  ];
}
