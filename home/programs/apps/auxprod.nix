{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    musescore
    reaper
    (callPackage ../../../pkgs/izotope {
      # TODO somehow make a global "wine package" definition that changes everything
      wine = inputs.nix-gaming.packages.${pkgs.system}.wine-tkg;
      location = "/home/tunnel/.izotope";
    })
  ];
}
