{inputs, ...}: {
  imports = [
    ./programs/terminal
    inputs.nix-index-database.hmModules.nix-index
    inputs.agenix.homeManagerModules.default
    inputs.chaotic.homeManagerModules.default
  ];

  home = {
    username = "tunnel";
    homeDirectory = "/home/tunnel";
    stateVersion = "23.11";
    extraOutputsToInstall = ["doc" "devdoc"];
  };

  age = {
    identityPaths = [
      "/home/tunnel/.ssh/agenix"
    ];
    secretsDir = "/home/tunnel/.secrets";
  };

  # disable manuals as nmd fails to build often
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };

  programs = {
    # use nix-index insteam of cnf
    command-not-found.enable = false;
    # let HM manage itself when in standalone mode
    home-manager.enable = true;
  };
}
