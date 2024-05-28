{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./btop.nix
    ./bat.nix
    ./fish.nix
    ./lf.nix
    ./ncmpcpp.nix
  ];

  home.packages = with pkgs; [
    (inputs.nixvim.legacyPackages."${system}".makeNixvimWithModule {
      inherit pkgs;
      module = ./vim;
    })
    grc
    ripgrep
    nil
    nom
    restic
    attic-client
    kubectl
  ];
  programs = {
    fd.enable = true;
    lazygit.enable = true;
    zellij = {
      enable = true;
      enableFishIntegration = true;
    };
    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      enableFishIntegration = true;
    };
    fzf = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}
