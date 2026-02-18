{
  inputs,
  lib,
  ...
}:
let
  polyModule = {
    agenix = {
      enable = true;
      enableReleaseChecks = false;
    };
  };
in
{
  flake.modules = {
    nixos.base = {
      imports = [
        inputs.agenix.nixosModules.agenix
        polyModule
      ];
      agenix.homeManagerIntegration.autoImport = false;
    };

    homeManager.base = {
      imports = [
        inputs.agenix.homeModules.agenix
        polyModule
      ];
    };

    nixOnDroid.base = {
      imports = [
        inputs.agenix.nixOnDroidModules.agenix
        polyModule
      ];
    };

    nixvim.base = nixvimArgs: {
      # https://github.com/danth/agenix/pull/415#issuecomment-2832398958
      imports = lib.optional (
        nixvimArgs ? homeConfig
      ) nixvimArgs.homeConfig.agenix.targets.nixvim.exportedModule;
    };
  };
}
