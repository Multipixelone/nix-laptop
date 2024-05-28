{
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}: {
  home = {
    username = "tunnel";
    homeDirectory = "/home/tunnel";
    sessionVariables = {
      EDITOR = "nvim";
    };
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
        init.defaultBranch = "main";
        branch.autosetupmerge = "true";
        merge.stat = "true";
        repack.usedeltabaseoffset = "true";
        rebase = {
          autoSquash = true;
          autoStash = true;
        };
        rerere = {
          enabled = true;
          autoupdate = true;
        };
      };
    };
    ssh = {
      enable = true;
      addKeysToAgent = "yes";
      forwardAgent = true;
    };
    command-not-found.enable = false;
    nix-index.enable = true;
    home-manager.enable = true;
  };
  home.stateVersion = "23.11";
}
