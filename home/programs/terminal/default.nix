{pkgs, ...}: {
  imports = [
    ./btop.nix
    ./bat.nix
    ./fish.nix
    ./yazi.nix
    ./ncmpcpp.nix
    ./media-dl.nix
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
    lazygit.enable = true;
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
    navi.enable = true;
    ripgrep.enable = true;
    gh.enable = true;
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
