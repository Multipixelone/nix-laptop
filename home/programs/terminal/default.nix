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
  age = {
    secrets = {
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
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;

      userName = "Multipixelone";
      userEmail = "finn@cnwr.net";

      ignores = [
        "*result*"
        ".direnv"
      ];

      extraConfig = {
        core = {
          editor = "hx";
          whitespace = "fix,-indent-with-non-tab,trailing-space,cr-at-eol";
        };
        pull = {
          ff = "only";
          rebase = false;
        };
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          stat = "true";
          conflictStyle = "diff3";
          tool = "diffview";
        };
        mergetool."diffview" = {
          cmd = "nvim -n -c \"DiffviewOpen\" \"$MERGE\"";
          prompt = false;
        };
        init.defaultBranch = "main";
        branch.autosetupmerge = "true";
        repack.usedeltabaseoffset = "true";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
        url = {
          "https://github.com/".insteadOf = "gh:";
          "ssh://git@github.com/".pushInsteadOf = "gh:";
          "https://gitlab.com/".insteadOf = "gl:";
          "ssh://git@gitlab.com/".pushInsteadOf = "gl:";
        };
      };
    };
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
