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
      ls = "eza --color=auto --icons --git";
      la = "eza --color=auto --icons --git -lah";
      tree = "eza --icons -T";
      ii = "systemd-inhibit --what=idle --who=Caffeine --why=Caffeine --mode=block sleep inf";
      mx = "chmod +x";
      vim = "nvim";
      top = "btop";
      lg = "lazygit";
      nixlg = "cd ~/Documents/Git/nix-laptop && lazygit";
      ciara = "echo \"i dont know\"";
      fetch = "nix run nixpkgs#nitch";
      ff = "nix run nixpkgs#fastfetch";
      alej = "nix run nixpkgs#alejandra .";
      zeldab = "nix build .#nixosConfigurations.zelda.config.system.build.toplevel && attic push tunnel result";
    };
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      set pure_enable_single_line_prompt true
      set pure_enable_nixdevshell true
      set pure_color_mute cyan
      set pure_check_for_new_release false
      set pure_color_primary white
      set pure_color_info blue
      fish_config theme choose "Catppuccin Mocha"
    '';
    plugins = [
      {
        name = "fish-exa";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-exa";
          rev = "92e5bcb762f7c08cc4484a2a09d6c176814ef35d";
          sha256 = "sha256-Dc/zdxfzAUM5NX8PxzfljRbYvO9f9syuLO8yBr+R3qg=";
        };
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
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
      {
        name = "pure";
        src = pkgs.fishPlugins.pure.src;
      }
    ];
  };
}
