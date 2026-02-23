{ config, ... }:
let
  inherit (config.flake.meta) repo;
  filename = "check.yaml";
  filePath = ".github/workflows/${filename}";

  workflowName = "Check";

  ids = {
    jobs = {
      getCheckNames = "get-check-names";
      check = "check";
    };
    steps.getCheckNames = "get-check-names";
    outputs = {
      jobs.getCheckNames = "checks";
      steps.getCheckNames = "checks";
    };
  };

  matrixParam = "checks";

  nixArgs = "--accept-flake-config";

  runner = {
    name = "ubuntu-latest";
    system = "x86_64-linux";
  };

  steps = {
    nothingButNix = {
      uses = "wimpysworld/nothing-but-nix@main";
      "with" = {
        hatchet-protocol = "holster";
      };
    };
    checkout = {
      uses = "actions/checkout@v4";
      "with".submodules = true;
    };
    detsysNixInstaller = {
      uses = "DeterminateSystems/nix-installer-action@main";
      "with".extra-conf = ''
        fallback = true
        http-connections = 128
        max-substitution-jobs = 128
        connect-timeout = 15
        stalled-download-timeout = 15
        download-attempts = 100
        substituters = https://nix-community.cachix.org/ https://chaotic-nyx.cachix.org/ https://cache.nixos.org https://helix.cachix.org https://yazi.cachix.org https://anyrun.cachix.org https://hyprland.cachix.org https://nix-community.cachix.org https://nix-gaming.cachix.org https://cache.nixos.org/ https://prismlauncher.cachix.org
        trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= system:XwpCBI5UHFzt9tEmiq3v8S062HvTqWPUwBR8PoHSfSk= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs= yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k= anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s= hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4= prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=
      '';
    };
    magicNixCache.uses = "DeterminateSystems/magic-nix-cache-action@main";
  };
in
{
  text.readme.parts = {
    ci-badge = ''
      <a href="https://github.com/${repo.owner}/${repo.name}/actions/workflows/${filename}?query=branch%3A${repo.defaultBranch}">
      <img
        alt="CI status"
        src="https://img.shields.io/${repo.forge}/actions/workflow/status/${repo.owner}/${repo.name}/${filename}?style=for-the-badge&branch=${repo.defaultBranch}&label=${workflowName}"
      >
      </a>

    '';
    github-actions = ''
      ## Running checks on GitHub Actions

      Running this repository's flake checks on GitHub Actions is merely a bonus
      and possibly more of a liability.

      Workflow files are generated using
      [the _files_ flake-parts module](https://github.com/mightyiam/files).

      For better visibility, a job is spawned for each flake check.
      This is done dynamically.

    ''
    + (
      assert steps ? nothingButNix;
      ''
        To prevent runners from running out of space,
        The action [Nothing but Nix](https://github.com/marketplace/actions/nothing-but-nix)
        is used.

      ''
    )
    + ''
      See [`modules/meta/ci.nix`](modules/meta/ci.nix).

    '';
  };

  perSystem =
    { pkgs, ... }:
    {
      files.files = [
        {
          path_ = filePath;
          drv = pkgs.writers.writeJSON "gh-actions-workflow-check.yaml" {
            name = workflowName;
            on = {
              push = { };
              workflow_call = { };
            };
            jobs = {
              ${ids.jobs.getCheckNames} = {
                runs-on = runner.name;
                outputs.${ids.outputs.jobs.getCheckNames} =
                  "\${{ steps.${ids.steps.getCheckNames}.outputs.${ids.outputs.steps.getCheckNames} }}";
                steps = [
                  steps.checkout
                  steps.detsysNixInstaller
                  steps.magicNixCache
                  {
                    id = ids.steps.getCheckNames;
                    run = ''
                      checks="$(nix ${nixArgs} eval --json .#checks.${runner.system} --apply builtins.attrNames)"
                      echo "${ids.outputs.steps.getCheckNames}=$checks" >> $GITHUB_OUTPUT
                    '';
                  }
                ];
              };

              ${ids.jobs.check} = {
                needs = ids.jobs.getCheckNames;
                runs-on = runner.name;
                strategy = {
                  fail-fast = false;
                  matrix.${matrixParam} =
                    "\${{ fromJson(needs.${ids.jobs.getCheckNames}.outputs.${ids.outputs.jobs.getCheckNames}) }}";
                };
                steps = [
                  steps.checkout
                  steps.nothingButNix
                  steps.detsysNixInstaller
                  steps.magicNixCache
                  {
                    run = ''
                      nix ${nixArgs} build '.#checks.${runner.system}."''${{ matrix.${matrixParam} }}"'
                    '';
                  }
                ];
              };
            };
          };
        }
      ];

      treefmt.settings.global.excludes = [ filePath ];
    };
}
