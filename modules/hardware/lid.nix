{ lib, ... }:
{
  flake.modules.nixos.base = {
    services = {
      logind.settings.Login = {
        HandleLidSwitchExernalPower = lib.mkDefault "ignore";
      };
    };
  };
}
