{
  pkgs,
  lib,
  ...
}:
{
  xdg.configFile."fish/completions/gh.fish".source =
    pkgs.runCommand "gh-completion"
      {
      }
      ''
        ${lib.getExe pkgs.gh} completion -s fish > $out
      '';
  programs = {
    gh.enable = true;
    lazygit.enable = true;
    delta = {
      enable = true;
      enableGitIntegration = true;
    };
    git = {
      enable = true;
      lfs.enable = true;

      ignores = [
        "*result*"
        ".direnv"
      ];
      settings = {
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
  };
}
