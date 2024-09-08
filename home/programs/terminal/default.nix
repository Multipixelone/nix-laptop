{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  # wrap secret into gh cli
  gh-wrapped = pkgs.writeShellScriptBin "gh" ''
    export GITHUB_TOKEN=$(cat ${config.age.secrets."gh".path})
    ${lib.getExe pkgs.gh} $@
  '';
in {
  imports = [
    ./btop.nix
    ./bat.nix
    ./fish.nix
    ./lf.nix
    ./ncmpcpp.nix
    ./helix.nix
    ./shell-script.nix
  ];
  age.secrets = {
    "gh" = {
      file = "${inputs.secrets}/github/ghcli.age";
    };
  };
  home.packages = with pkgs; [
    # (inputs.nixvim.legacyPackages."${system}".makeNixvimWithModule {
    #   inherit pkgs;
    #   module = ./vim;
    # })
    grc
    ripgrep
    nil
    nom
    restic
    attic-client
    kubectl
    flyctl
    unzip
    p7zip
  ];
  programs = {
    fd.enable = true;
    lazygit.enable = true;
    jq.enable = true;
    yt-dlp.enable = true;
    gh = {
      enable = true;
      package = gh-wrapped;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [];
    };
    zellij = {
      enable = true;
      enableFishIntegration = false; # launches on every open of shell
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
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = ["--height 20%"]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };
  };
}
