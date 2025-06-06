{
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];
  programs.nixcord = {
    enable = true;
    config = {
      frameless = true;
      themeLinks = [
        "https://catppuccin.github.io/discord/dist/catppuccin-${config.catppuccin.flavor}-${config.catppuccin.accent}.theme.css"
      ];
      plugins = {
        petpet.enable = true;
        readAllNotificationsButton.enable = true;
        spotifyCrack.enable = true;
        whoReacted.enable = true;
        youtubeAdblock.enable = true;
        webScreenShareFixes.enable = true;
      };
    };
  };
}
