{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./btop.nix
    ./bat.nix
    ./pager.nix
    ./fish
    ./yazi.nix
    ./rmpc.nix
    ./git.nix
    ./wrapped.nix
    ./helix.nix
    ./shell-script.nix
    ./ssh.nix
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
    zip
    p7zip
    ouch
  ];
  home.shell.enableFishIntegration = true;
  programs = {
    fd.enable = true;
    jq.enable = true;
    carapace.enable = true;
    navi.enable = true;
    ripgrep.enable = true;
    zoxide.enable = true;
    nix-index.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    dircolors = {
      enable = true;
    };
    eza = {
      inherit (config.home.shell) enableFishIntegration;
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
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
      defaultOptions = [
        "--multi"
        "--reverse"
        "--info inline"
        "--bind=ctrl-f:page-down,ctrl-b:page-up,ctrl-y:accept"
        "--height=40%"
      ];
      fileWidgetOptions = [
        "--preview 'bat -n --color=always --style=header,grid --line-range :500 {}'"
      ];
      changeDirWidgetOptions = [
        "--preview 'eza --tree --color=always {} | head -200'"
      ];
    };
  };
}
