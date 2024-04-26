{pkgs, inputs, ...}: {
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
    eza
    fzf
    fd
    grc
    btop
    lazygit
    bat
    zellij
    ripgrep
    nil
    nom
    restic
    attic-client
  ];
}
