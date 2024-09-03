{
  pkgs,
  inputs,
  ...
}: {
  home = {
    username = "tunnel";
    homeDirectory = "/home/tunnel";
  };
  imports = [
    ./programs/terminal/default.nix
    inputs.nix-index-database.hmModules.nix-index
  ];
  home.packages = with pkgs; [
    sysstat
    just
    i2c-tools
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb
  ];
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      delta.enable = true;

      userName = "Multipixelone";
      userEmail = "finn@cnwr.net";

      extraConfig = {
        core = {
          editor = "nvim";
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
          "ssh://git@github.com".pushInsteadOf = "gh:";
          "https://gitlab.com/".insteadOf = "gl:";
          "ssh://git@gitlab.com".pushInsteadOf = "gl:";
        };
      };
    };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
    # use nix-index insteam of cnf
    command-not-found.enable = false;
    nix-index = {
      enable = true;
      enableFishIntegration = true;
    };
    home-manager.enable = true;
  };
  home.stateVersion = "23.11";
}
