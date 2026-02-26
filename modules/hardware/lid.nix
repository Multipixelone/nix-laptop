{ lib, ... }:
{
  flake.modules.nixos.base = {
    services = {
      logind.settings.Login = {
        HandleLidSwitch = lib.mkDefault "ignore";
        HandleLidSwitchExternalPower = lib.mkDefault "ignore";
        HandleLidSwitchDocked = lib.mkDefault "ignore";
      };
    };
  };
}
