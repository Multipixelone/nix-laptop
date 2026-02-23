{
  flake.modules.homeManager.base = {
    programs = {
      lazygit = {
        enable = true;
        settings = {
          notARepository = "quit";
          disableStartupPopups = true;
          gui = {
            nerdFontsVersion = "3";
            showBranchCommitHash = true;
          };
        };
      };
      delta = {
        enable = true;
        enableGitIntegration = true;
      };
      git = {
        enable = true;
        lfs.enable = true;

        ignores = [
          "*result*"
        ];
        settings = {
          user = {
            name = "Multipixelone";
            email = "finn@cnwr.net";
          };
          pull = {
            ff = "only";
            rebase = false;
          };
          push = {
            default = "current";
            autoSetupRemote = true;
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
        };
      };
    };
  };
}
