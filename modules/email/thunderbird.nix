{
  flake.modules.homeManager.gui = {
    programs.thunderbird = {
      enable = true;
      profiles = {
        finn = {
          isDefault = true;
        };
      };
    };
  };
}
