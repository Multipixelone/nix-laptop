{
  config,
  pkgs,
  nix-gaming,
  ...
}: {
  home.file.".config/fish/themes/Catppuccin Mocha.theme".source = pkgs.fetchurl {
    name = "Catppuccin Mocha.theme";
    url = "https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Mocha.theme";
    sha256 = "sha256-MlI9Bg4z6uGWnuKQcZoSxPEsat9vfi5O1NkeYFaEb2I=";
  };
  programs.fish = {
    enable = true;
    shellAbbrs = {
      c = "clear";
      ls = "exa --color=auto --icons --git";
      la = "exa --color=auto --icons --git -lah";
      ii = "systemd-inhibit --what=idle --who=Caffeine --why=Caffeine --mode=block sleep inf";
      vim = "nvim";
      lg = "nix run nixpkgs#lazygit";
      fetch = "nix run nixpkgs#nitch";
      ff = "nix run nixpkgs#fastfetch";
      alej = "nix run nixpkgs#alejandra .";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fish_config theme choose "Catppuccin Mocha"
    '';
    plugins = [
      {
        name = "catppuccin";
        src = pkgs.fetchFromGitHub {
          owner = "catppuccin";
          repo = "fish";
          rev = "0ce27b518e8ead555dec34dd8be3df5bd75cff8e";
          sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
        };
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
      {
        name = "hydro";
        src = pkgs.fishPlugins.hydro.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "pisces";
        src = pkgs.fishPlugins.pisces.src;
      }
      {
        name = "grc";
        src = pkgs.fishPlugins.grc.src;
      }
    ];
  };
}
