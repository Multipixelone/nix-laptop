{
  inputs,
  pkgs,
  ...
}: {
  # themable spotify
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;

    theme = spicePkgs.themes.dribbblish;

    colorScheme = "catppuccin-mocha";

    enabledCustomApps = with spicePkgs.customApps; [
      lyricsPlus
    ];

    enabledExtensions = with spicePkgs.extensions; [
      powerBar
      fullAppDisplayMod
      history
      hidePodcasts
      shuffle
      playlistIcons
    ];
  };
}
