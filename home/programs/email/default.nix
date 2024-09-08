{...}: {
  programs.thunderbird = {
    enable = true;
    profiles = {
      finn = {
        isDefault = true;
      };
    };
  };
}
