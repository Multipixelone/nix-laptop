{
  pkgs,
  lib,
  ...
}: let
  cliphist = lib.getExe pkgs.cliphist;
  wl-copy = lib.getExe' pkgs.wl-clipboard "wl-copy";
  fzf-config = ''
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';
  pure-config = ''
    set pure_enable_single_line_prompt true
    set pure_enable_nixdevshell true
    set pure_color_mute cyan
    set pure_check_for_new_release false
    set pure_color_primary white
    set pure_color_info blue
  '';
  fish-config =
    ''
      set fish_greeting # Disable greeting
    ''
    + fzf-config
    + pure-config;
in {
  programs.fish = {
    enable = true;
    shellAbbrs = {
      c = "clear";
      # TODO fix idle inhibit command
      # ii = "systemd-inhibit --what=idle --who=Caffeine --why=Caffeine --mode=block sleep inf";
      mx = "chmod +x";
      lg = "lazygit";
      nixlg = "cd ~/Documents/Git/nix-laptop && lazygit";
      fetch = "nix run nixpkgs#nitch";
      ff = "nix run nixpkgs#fastfetch";
      hypr-log = "tail -f /run/user/1000/hypr/$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)/hyprland.log";
      # TODO Split this into commands based on hostname
      pw-get = "pactl load-module module-null-sink media.class=Audio/Sink sink_name=music channel_map=stereo && pactl load-module module-native-protocol-tcp port=4656 listen=192.168.6.6";
      pw-send = "pactl load-module module-tunnel-sink server=tcp:192.168.6.6:4656";
      nsp = "nix-shell -p";
    };
    shellAliases = {
      ls = "eza";
      la = "eza -lah";
      tree = "eza -s type -a -T -I '.git|node_modules|.next'";
      du = lib.getExe pkgs.ncdu + " --color dark -rr -x";
      clip = "${cliphist} list | fzf | ${cliphist} decode | ${wl-copy}";
      ping = lib.getExe pkgs.prettyping;
    };
    shellInit = fish-config;
    interactiveShellInit = ''
      ${lib.getExe pkgs.any-nix-shell} fish --info-right | source
    '';
    functions = {
      nvimrg = "nvim -q (rg --vimgrep $argv | psub)";
    };
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
