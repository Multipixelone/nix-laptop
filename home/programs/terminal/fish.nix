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
  # pure-config = ''
  #   set pure_enable_single_line_prompt true
  #   set pure_enable_nixdevshell true
  #   set pure_color_mute cyan
  #   set pure_check_for_new_release false
  #   set pure_color_primary white
  #   set pure_color_info blue
  # '';
  fish-config =
    ''
      set fish_greeting # Disable greeting
    ''
    + fzf-config;
  # + pure-config;
in {
  programs.fish = {
    enable = true;
    shellAbbrs = let
      bat-args = command: args: command + (" | bat " + args);
    in {
      c = "clear";
      # TODO fix idle inhibit command
      # ii = "systemd-inhibit --what=idle --who=Caffeine --why=Caffeine --mode=block sleep inf";
      # fish
      h = bat-args "history" "-l fish";
      lsabbrs = bat-args "abbr" "-l fish";
      mx = "chmod +x";
      lg = "lazygit";
      nixlg = "cd ~/Documents/Git/nix-laptop && lazygit";
      fetch = "nix run nixpkgs#nitch";
      upset = "nix run github:Multipixelone/upset";
      ff = "nix run nixpkgs#fastfetch";
      hypr-log = "tail -f /run/user/1000/hypr/$(find /run/user/1000/hypr/ -mindepth 1 -printf '%P\n' -prune)/hyprland.log";
      # TODO Split this into commands based on hostname
      pw-get = "pactl load-module module-null-sink media.class=Audio/Sink sink_name=music channel_map=stereo && pactl load-module module-native-protocol-tcp port=4656 listen=192.168.6.6";
      pw-send = "pactl load-module module-tunnel-sink server=tcp:192.168.6.6:4656";
      nsp = "nix-shell -p";
      nb = "nix build";
      nr = "nix run";
      kh = "khinsider";
    };
    shellAliases = {
      ls = "eza";
      la = "eza -lah";
      fzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
      mkdir = "mkdir -pv";
      tree = "eza -s type -a -T -I '.git|node_modules|.next'";
      du = lib.getExe pkgs.ncdu + " --color dark -rr -x";
      df = lib.getExe pkgs.duf;
      clip = "${cliphist} list | fzf | ${cliphist} decode | ${wl-copy}";
      ping = lib.getExe pkgs.prettyping;
      public-ip = lib.getExe' pkgs.dnsutils "dig" + " +short myip.opendns.com @resolver1.opendns.com";
    };
    shellInit = fish-config;
    interactiveShellInit = ''
      if status is-interactive
            if type -q zellij
                # Update the zellij tab name with the current process name or pwd.
                function zellij_tab_name_update_pre --on-event fish_preexec
                    if set -q ZELLIJ
                        set -l cmd_line (string split " " -- $argv)
                        set -l process_name $cmd_line[1]
                        if test -n "$process_name" -a "$process_name" != "z"
                            command nohup zellij action rename-tab $process_name >/dev/null 2>&1
                            if test "$process_name" = "hx"
                              command nohup zellij action switch-mode locked >/dev/null 2>&1
                            end
                        end
                    end
                end

                function zellij_tab_name_update_post --on-event fish_postexec
                    if set -q ZELLIJ
                        set -l cmd_line (string split " " -- $argv)
                        set -l process_name $cmd_line[1]
                        command nohup zellij action switch-mode normal >/dev/null 2>&1
                        if test "$process_name" = "z"
                            command nohup zellij action rename-tab (prompt_pwd) >/dev/null 2>&1
                        end
                    end
                end
            end
        end
    '';
    functions = {
      __onefetch_on_pwd_change = {
        # body = "__onefetch_on_pwd_change --on-variable PWD";
        onVariable = "PWD";
        body = ''
          if test -d ./.git
            ${lib.getExe pkgs.onefetch} --no-art
          end
        '';
      };
      fish_command_not_found = ''
        # If you run the command with comma, running the same command
        # will not prompt for confirmation for the rest of the session
        if contains $argv[1] $__command_not_found_confirmed_commands
          or ${lib.getExe pkgs.gum} confirm --no-show-help --selected.background=2 "Run using comma?"

          # Not bothering with capturing the status of the command, just run it again
          if not contains $argv[1] $__command_not_found_confirmed_commands
            set -ga __command_not_found_confirmed_commands $argv[1]
          end

          ${lib.getExe pkgs.comma} -- $argv
          return 0
        else
          __fish_default_command_not_found_handler $argv
        end
      '';
    };
    plugins = [
      {
        name = "fish-exa";
        src = pkgs.fetchFromGitHub {
          owner = "gazorby";
          repo = "fish-exa";
          rev = "92e5bcb762f7c08cc4484a2a09d6c176814ef35d";
          sha256 = "sha256-kw4XrchvF4SNNoX/6HRw2WPvCxKamwuTVWdHg82Pqac=";
        };
      }
      {
        name = "fzf-fish";
        inherit (pkgs.fishPlugins.fzf-fish) src;
      }
      {
        name = "done";
        inherit (pkgs.fishPlugins.done) src;
      }
      {
        name = "pisces";
        inherit (pkgs.fishPlugins.pisces) src;
      }
      {
        name = "grc";
        inherit (pkgs.fishPlugins.grc) src;
      }
      # {
      #   name = "pure";
      #   src = pkgs.fishPlugins.pure.src;
      # }
    ];
  };
}
