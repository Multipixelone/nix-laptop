{ config, ... }:
let
  inherit (config.flake.meta) repo;
  inherit (config.flake.meta.accounts) github;
  cloneUrl = "git@${github.domain}:${repo.owner}/${repo.name}.git";
in
{
  flake.modules.homeManager.base =
    hmArgs@{ pkgs, lib, ... }:
    let
      projectsDir = "${hmArgs.config.home.homeDirectory}/Documents/Git";
      repoDir = "${projectsDir}/${repo.name}";
    in
    {
      home.sessionVariables.PROJECTS_DIR = projectsDir;

      home.activation.cloneSelf = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        if [ ! -d ${lib.escapeShellArg "${repoDir}/.git"} ]; then
          $DRY_RUN_CMD mkdir -p ${lib.escapeShellArg projectsDir}
          $DRY_RUN_CMD ${lib.getExe pkgs.git} clone --recurse-submodules \
            ${lib.escapeShellArg cloneUrl} \
            ${lib.escapeShellArg repoDir} \
            || echo "Warning: failed to clone ${repo.name}. Clone it manually into ${lib.escapeShellArg projectsDir}."
        fi
      '';
    };
}
