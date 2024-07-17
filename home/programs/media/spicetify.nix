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

    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      history
      hidePodcasts
      shuffle
      playlistIcons
    ];
  };
}
