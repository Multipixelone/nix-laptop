{inputs, ...}: {
  programs.fish.enable = true;
  programs.command-not-found.enable = false;
  nixpkgs.overlays = [
    (_final: prev: {
      zjstatus = inputs.zjstatus.packages.${prev.system}.default;
    })
  ];
}
