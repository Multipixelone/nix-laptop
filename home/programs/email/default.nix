_: {
  services.protonmail-bridge = {
    enable = true;
  };
  programs.thunderbird = {
    enable = true;
    profiles = {
      finn = {
        isDefault = true;
      };
    };
  };
}
