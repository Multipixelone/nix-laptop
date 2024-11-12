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
  # wrap secret into tgpt
  tgpt-wrapped = pkgs.writeShellScriptBin "tgpt" ''
    export AI_PROVIDER="openai"
    export OPENAI_MODEL="gpt-4o-mini" # use 4o-mini TODO: use bash variable expansion to set this value if unset.
    export OPENAI_API_KEY=$(cat ${config.age.secrets."openai".path})
    ${lib.getExe pkgs.tgpt} $@
  '';
  # wrap secret into todoist
  todoist-wrapped = pkgs.writeShellScriptBin "td" ''
    export TODOIST_TOKEN=$(cat ${config.age.secrets."todoist".path})
    ${lib.getExe pkgs.todoist} $@
  '';
  # wrap client id and secret into gcalcli
  gcalcli-wrapped = pkgs.writeShellScriptBin "gcalcli" ''
    ${lib.getExe pkgs.gcalcli} \
    --client-id=$(cat ${config.age.secrets."gcalclient".path}) \
    --client-secret=$(cat ${config.age.secrets."gcalsecret".path}) \
    $@
  '';
in {
  imports = [
    ./btop.nix
    ./bat.nix
    ./fish.nix
    ./yazi.nix
    ./ncmpcpp.nix
    ./helix.nix
    ./shell-script.nix
    ./zellij.nix
    ./starship.nix
  ];
  age.secrets = {
    "gh" = {
      file = "${inputs.secrets}/github/ghcli.age";
    };
    "openai" = {
      file = "${inputs.secrets}/openai.age";
    };
    "todoist" = {
      file = "${inputs.secrets}/todoist.age";
    };
    "gcalclient" = {
      file = "${inputs.secrets}/gcal/client.age";
    };
    "gcalsecret" = {
      file = "${inputs.secrets}/gcal/secret.age";
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
    ouch
    tgpt-wrapped
    todoist-wrapped
    gcalcli-wrapped
  ];
  programs = {
    fd.enable = true;
    lazygit.enable = true;
    jq.enable = true;
    yt-dlp = {
      enable = true;
      settings = {
        embed-thumbnail = true;
        embed-metadata = true;
        embed-chapters = true;
        embed-subs = true;
        sponsorblock-mark = "all";
        sponsorblock-remove = "sponsor";
        downloader = "aria2c";
        downloader-args = "aria2c:'-c -x8 -s8 -k1M'";
      };
    };
    navi.enable = true;
    aria2.enable = true;
    ripgrep.enable = true;
    gh = {
      enable = true;
      package = gh-wrapped;
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [];
    };
    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
    eza = {
      enable = true;
      git = true;
      icons = "auto";
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
