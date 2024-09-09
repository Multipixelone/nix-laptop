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
    navi.enable = true;
    aria2.enable = true;
    ripgrep.enable = true;
    taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
    };
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
      settings = {
        pane_frames = false;
      };
    };
    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      git = true;
      icons = true;
      enableFishIntegration = true;
      extraOptions = [
        "--color=auto"
      ];
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
