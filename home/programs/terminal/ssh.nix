{ config, ... }:
let
  # uid = config.users.users.tunnel.uid;
  # fixedSshAgentSocket = "/run/user/${builtins.toString uid}/sshagent";
in
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = true;
        addKeysToAgent = "yes";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };
      "git" = {
        host = "github.com gitlab.com";
        identitiesOnly = true;
        identityFile = [ "~/.ssh/id_ed25519" ];
      };
    };
  };
}
