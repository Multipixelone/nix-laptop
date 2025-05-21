{pkgs, ...}: {
  imports = [
    ./btop.nix
    ./bat.nix
    ./fish.nix
    ./yazi.nix
    ./ncmpcpp.nix
    ./media-dl.nix
    ./git.nix
    ./wrapped.nix
    ./helix.nix
    ./shell-script.nix
    ./zellij.nix
    ./starship.nix
  ];
  home.packages = with pkgs; [
    grc
    nil
    nom
    restic
    kubectl
    flyctl
    unzip
    p7zip
    ouch
  ];
  home.shell.enableFishIntegration = true;
  programs = {
    fd.enable = true;
    jq.enable = true;
    carapace.enable = true;
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
    nix-index.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    navi.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
    dircolors = {
      enable = true;
    };
    eza = {
      enable = true;
      git = true;
      icons = "auto";
      extraOptions = [
        "--color=auto"
      ];
    };
    fzf = {
      enable = true;
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = ["--height 20%"]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };
  };
}
