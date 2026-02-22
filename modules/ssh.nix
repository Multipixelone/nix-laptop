{ lib, config, ... }:
let
  reachableNixoss =
    config.flake.nixosConfigurations
    |> lib.filterAttrs (
      _name: nixos:
      !(lib.any isNull [
        nixos.config.networking.domain
        nixos.config.networking.hostName
        nixos.config.services.openssh.publicKey
      ])
    );
in
{
  flake.modules = {
    nixos.base = {
      options.services.openssh.publicKey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
      };

      config = {
        programs.mosh = {
          enable = true;
          openFirewall = true;
        };

        services.openssh = {
          enable = true;
          openFirewall = true;

          settings = {
            PasswordAuthentication = false;
          };

          extraConfig = ''
            Include /etc/ssh/sshd_config.d/*
          '';
        };

        users.users.${config.flake.meta.owner.username}.openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfFq+1W21NoXAyFc1HT5zJ7GAVDbQw/f6reJI3X2vtn link"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK5bqb1RiYN2X5dx4GKlTgeiWhYWHQhiV/HU1MtOZfFt zelda"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBK7HXtVv6LFt7sH5QUrj80iqtaUmYJuf7eBwmsdzni7epBfrX2iyZzzXtIDSdgPaOhSJp5FJIkBvA6UMMkveYbM= iphone"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBBGm2epY8mE3z7qoL10fXmBuv4EPHnQoqJoYrL9TgfJwhnZMsaf1FQ2jalGSCE6T+QuYF/WM+bIWxZiYrT/XisM= ipad"
        ];

        programs.ssh.knownHosts =
          reachableNixoss
          |> lib.mapAttrs (
            _name: nixos: {
              hostNames = [ nixos.config.networking.fqdn ];
              inherit (nixos.config.services.openssh) publicKey;
            }
          );
      };
    };

    homeManager.base = args: {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        includes = [ "${args.config.home.homeDirectory}/.ssh/hosts/*" ];
        matchBlocks =
          reachableNixoss
          |> lib.mapAttrsToList (
            _name: nixos: {
              "${nixos.config.networking.fqdn}" = {
                identityFile = "~/.ssh/keys/infra_ed25519";
              };
            }
          )
          |> lib.concat [
            {
              "*" = {
                setEnv.TERM = "xterm-256color";
                compression = true;
                identitiesOnly = true;
                hashKnownHosts = false;
                identityFile = "${args.config.home.homeDirectory}/.ssh/id_ed25519";
                forwardAgent = true;
                addKeysToAgent = "yes";
                serverAliveInterval = 0;
                serverAliveCountMax = 3;
                userKnownHostsFile = "~/.ssh/known_hosts";
                controlMaster = "no";
                controlPath = "~/.ssh/master-%r@%n:%p";
                controlPersist = "no";
              };
            }
          ]
          |> lib.mkMerge;
      };
    };
  };
}
