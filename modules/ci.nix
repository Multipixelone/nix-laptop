{ config, lib, ... }:
let
  inherit (config.flake.meta) repo;

  caches = [
    {
      url = "https://nix-community.cachix.org/";
      key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    }
    {
      url = "https://chaotic-nyx.cachix.org/";
      key = "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=";
    }
    {
      url = "https://cache.nixos.org/";
      key = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=";
    }
    {
      url = "https://helix.cachix.org";
      key = "helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs=";
    }
    {
      url = "https://yazi.cachix.org";
      key = "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=";
    }
    {
      url = "https://anyrun.cachix.org";
      key = "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s=";
    }
    {
      url = "https://hyprland.cachix.org";
      key = "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
    }
    {
      url = "https://nix-gaming.cachix.org";
      key = "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=";
    }
    {
      url = "https://prismlauncher.cachix.org";
      key = "prismlauncher.cachix.org-1:9/n/FGyABA2jLUVfY+DEp4hKds/rwO+SCOtbOkDzd+c=";
    }
  ];

  atticCache = {
    url = "https://attic-cache.fly.dev/system?priority=50";
    key = "system:XwpCBI5UHFzt9tEmiq3v8S062HvTqWPUwBR8PoHSfSk=";
  };

  mkNixConf =
    {
      extraSubstituters ? [ ],
    }:
    let
      substituters = lib.concatStringsSep " " ((map (c: c.url) caches) ++ extraSubstituters);
      trustedKeys = lib.concatStringsSep " " (map (c: c.key) (caches ++ [ atticCache ]));
    in
    ''
      fallback = true
      http-connections = 128
      max-substitution-jobs = 128
      connect-timeout = 15
      stalled-download-timeout = 15
      download-attempts = 100
      substituters = ${substituters}
      trusted-public-keys = ${trustedKeys}
    '';

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
    removeUnusedSoftware = {
      name = "Remove unused toolkits";
      run = ''
        sudo rm -rf $AGENT_TOOLSDIRECTORY
        sudo rm -rf /usr/local/.ghcup
        sudo rm -rf /usr/local/share/powershell
        sudo rm -rf /usr/local/share/chromium
        sudo rm -rf /usr/local/lib/node_modules
        sudo rm -rf /usr/local/lib/heroku
        sudo rm -rf /var/lib/docker/overlay2
        sudo rm -rf /home/linuxbrew
        sudo rm -rf /home/runner/.rustup
      '';
    };
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
    nixInstaller = {
      uses = "nixbuild/nix-quick-install-action@v34";
      "with" = {
        nix_version = "2.31.2";
        nix_conf = mkNixConf { extraSubstituters = [ atticCache.url ]; };
      };
    };
    createAtticNetrc = {
      name = "Create attic netrc";
      run = ''
        sudo mkdir -p /etc/nix
        echo "machine attic-cache.fly.dev password ''${{ secrets.ATTIC_KEY }}" | sudo tee /etc/nix/netrc > /dev/null
        git config --global url."https://''${{ secrets.GH_TOKEN_FOR_UPDATES }}@github.com".insteadOf https://github.com
      '';
    };
    installSshKey = {
      name = "Install SSH key";
      uses = "webfactory/ssh-agent@v0.9.0";
      "with".ssh-private-key = "\${{ secrets.SSH_PRIVATE_KEY }}";
    };
    loginToAttic = {
      name = "Login to attic";
      run = ''
        nix run nixpkgs#attic-client login fly https://attic-cache.fly.dev ''${{ secrets.ATTIC_KEY }}
      '';
    };
    pushToAttic = {
      name = "Push to attic";
      continue-on-error = true;
      run = ''
        nix run nixpkgs#attic-client push system result -j 3
      '';
    };
  };

  ciFilename = "ci.yml";
  ciFilePath = ".github/workflows/${ciFilename}";
  # ciWorkflowName = "CI";
  # ciRunner = "ubuntu-24.04";

  # machines = [
  #   {
  #     host = "minish";
  #     platform = "x86-64-linux";
  #   }
  #   {
  #     host = "link";
  #     platform = "x86-64-linux";
  #   }
  #   {
  #     host = "marin";
  #     platform = "x86-64-linux";
  #   }
  # ];

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
                  steps.removeUnusedSoftware
                  steps.checkout
                  steps.createAtticNetrc
                  steps.nixInstaller
                  steps.installSshKey
                  steps.loginToAttic
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
                  steps.removeUnusedSoftware
                  steps.checkout
                  steps.createAtticNetrc
                  steps.nixInstaller
                  steps.installSshKey
                  steps.loginToAttic
                  {
                    run = ''
                      nix run github:Mic92/nix-fast-build -- --skip-cached --no-nom --attic-cache system --flake '.#checks.${runner.system}."''${{ matrix.${matrixParam} }}"'
                    '';
                  }
                  # steps.pushToAttic
                ];
              };
            };
          };
        }
        # {
        #   path_ = ciFilePath;
        #   drv = pkgs.writers.writeJSON "gh-actions-workflow-ci.yml" {
        #     name = ciWorkflowName;
        #     on = {
        #       push.branches = [ "main" ];
        #       pull_request = { };
        #       workflow_dispatch = { };
        #     };
        #     jobs = {
        #       checks = {
        #         uses = "./${filePath}";
        #         secrets = "inherit";
        #       };
        #       build = {
        #         name = "build machines";
        #         needs = "checks";
        #         runs-on = ciRunner;
        #         strategy = {
        #           fail-fast = false;
        #           matrix.machine = machines;
        #         };
        #         steps = [
        #           ciSteps.mkdirNix
        #           steps.removeUnusedSoftware
        #           ciSteps.maximizeDiskSpace
        #           ciSteps.chownNix
        #           ciSteps.checkout
        #           steps.createAtticNetrc
        #           ciSteps.nixInstaller
        #           steps.installSshKey
        #           steps.loginToAttic
        #           ciSteps.buildSystem
        #           steps.pushToAttic
        #         ];
        #       };
        #     };
        #   };
        # }
      ];

      treefmt.settings.global.excludes = [
        filePath
        ciFilePath
      ];
    };
}
