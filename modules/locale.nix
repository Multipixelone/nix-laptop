{
  flake.modules.nixos.base = {
    documentation.dev.enable = true;

    i18n = {
      defaultLocale = "en_US.UTF-8";
      # saves space
      supportedLocales = [
        "en_US.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
      ];
    };

  };
}
