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
    jq.enable = true;
    zellij = {
      enable = true;
      # launches on every open of shell
      # enableFishIntegration = true;
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
