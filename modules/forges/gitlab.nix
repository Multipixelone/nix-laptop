{
  flake = {
    meta.accounts.gitlab = {
      domain = "gitlab.com";
      username = "tunnelmaker";
    };

    modules.nixos.base = {
      # https://docs.gitlab.com/user/gitlab_com/#ssh-known_hosts-entries
      programs.ssh.knownHosts."gitlab.com".publicKey =
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    };
    modules.homeManager.base = {
      programs.git.settings.url = {
        "https://gitlab.com/".insteadOf = "gl:";
        "ssh://git@gitlab.com/".pushInsteadOf = "gl:";
      };
    };
  };
}
