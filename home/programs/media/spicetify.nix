{
  inputs,
  pkgs,
  ...
}: {
  # themable spotify
  imports = [
    inputs.spicetify-nix.homeManagerModule
  ];

  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
    spicetify-themes = pkgs.fetchgit {
      url = "https://github.com/spicetify/spicetify-themes";
      rev = "4d596125c52b8ffc3fb4a7a243d0c37e9892b150";
      sha256 = "sha256-ziGeoK9TshSk7Md4fCCaUwfrrKBBXWsTiW8ZyOAo2pM=";
    };
  in {
    enable = true;

    theme = {
      name = "Dribbblish";
      src = spicetify-themes;
      requiredExtensions = [
        {
          filename = "dribbblish.js";
          src = "${spicetify-themes}/Dribbblish";
        }
      ];
      appendName = true;
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = true;
    };

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
