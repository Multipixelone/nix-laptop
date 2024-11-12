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
      directory = {
        home_symbol = "⌂ ";
        truncation_length = 10;
        truncation_symbol = "□ ";
        read_only = " ◈";
        use_os_path_sep = true;
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold blue";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [ ](bold bright-blue)";
      };
      format = lib.concatStrings [
        # "($nix_shell$container$git_metrics)$cmd_duration"
        "$localip"
        "$sudo"
        "$directory"
        "$git_status"
        "$git_metrics"
        "$character"
      ];
    };
  };
}
