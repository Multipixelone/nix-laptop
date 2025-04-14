{lib, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      directory.style = "blue";
      character = {
        format = "$symbol ";
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      git_metrics = {
        format = "([▴$added]($added_style))([▿$deleted]($deleted_style))";
        added_style = "italic dimmed green";
        deleted_style = "italic dimmed red";
        ignore_submodules = true;
        disabled = false;
      };
      git_status = {
        style = "bold italic bright-blue";
        format = "([$ahead_behind$staged$modified$untracked$renamed$deleted$conflicted$stashed]($style))";
        conflicted = "[◪◦](italic bright-magenta)";
        ahead = ''
          [▴│[''${count}](bold white)│](italic green)'';
        behind = ''
          [▿│[''${count}](bold white)│](italic red)'';
        diverged = ''[◇ ▴┤[''${ahead_count}](regular white)│▿┤[''${behind_count}](regular white)│](italic bright-magenta)'';
        untracked = "[◌◦](italic bright-yellow)";
        stashed = "[◃◈](italic white)";
        modified = "[●◦](italic yellow)";
        staged = "[▪┤[$count](bold white)│](italic bright-cyan)";
        renamed = "[◎◦](italic bright-blue)";
        deleted = "[✕](italic red)";
      };
      git_branch = {
        symbol = "";
        truncation_symbol = "⋯";
        truncation_length = 11;
        format = "$symbol $branch";
        ignore_branches = [
          "main"
          "master"
        ];
      };
      directory = {
        # home_symbol = "⌂ ";
        truncation_length = 3;
        truncation_symbol = "…/";
        read_only = " ◈";
        use_os_path_sep = true;
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold blue";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [ ](bold bright-blue)";
      };
      nix_shell = {
        style = "dimmed blue";
        symbol = "✶";
        format = "[$symbol $state ]($style) [$name](italic dimmed white)";
        impure_msg = "[⌽](bold dimmed red)";
        pure_msg = "[⌾](bold dimmed green)";
        unknown_msg = "[◌](bold dimmed ellow)";
      };
      format = lib.concatStrings [
        # "($nix_shell$container$git_metrics)$cmd_duration"
        "$localip"
        "$sudo"
        "$hostname"
        "$directory"
        "$git_status"
        "$git_metrics"
        "$git_branch"
        "$nix_shell"
        "$character"
      ];
      right_format = lib.concatStrings [
        "$singularity"
        "$kubernetes"
        "$vcsh"
        "$fossil_branch"
        "$hg_branch"
        "$pijul_channel"
        "$docker_context"
        "$package"
        "$c"
        "$cmake"
        "$cobol"
        "$daml"
        "$dart"
        "$deno"
        "$dotnet"
        "$elixir"
        "$elm"
        "$erlang"
        "$fennel"
        "$golang"
        "$guix_shell"
        "$haskell"
        "$haxe"
        "$helm"
        "$java"
        "$julia"
        "$kotlin"
        "$gradle"
        "$lua"
        "$nim"
        "$nodejs"
        "$ocaml"
        "$opa"
        "$perl"
        "$php"
        "$pulumi"
        "$purescript"
        "$python"
        "$raku"
        "$rlang"
        "$red"
        "$ruby"
        "$rust"
        "$scala"
        "$solidity"
        "$swift"
        "$terraform"
        "$vlang"
        "$vagrant"
        "$zig"
        "$buf"
        "$conda"
        "$meson"
        "$spack"
        "$memory_usage"
        "$aws"
        "$gcloud"
        "$openstack"
        "$azure"
        "$crystal"
        "$custom"
        "$status"
        "$os"
        "$battery"
        "$time"
      ];
    };
  };
}
