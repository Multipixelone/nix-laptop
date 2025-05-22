{inputs, ...}: {
  imports = [
    inputs.preservation.nixosModules.default
  ];
  systemd.suppressedSystemUnits = ["systemd-machine-id-commit.service"];
  users.users.tunnel.passwordFile = "/persist/passwords/tunnel";
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];
      directories = [
        "/var/lib/systemd/timers"
        "/var/lib/nixos"
      ];
    };
  };
}
