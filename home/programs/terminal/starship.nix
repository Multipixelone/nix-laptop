{lib, ...}: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      directory.style = "blue";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      directory = {
        home_symbol = "⌂";
        truncation_length = 2;
        truncation_symbol = "□ ";
        read_only = " ◈";
        use_os_path_sep = true;
        format = "[$path]($style)[$read_only]($read_only_style)";
        repo_root_style = "bold blue";
        repo_root_format = "[$before_root_path]($before_repo_root_style)[$repo_root]($repo_root_style)[$path]($style)[$read_only]($read_only_style) [△](bold bright-blue)";
      };
      format = lib.concatStrings [
        "($nix_shell$container$git_metrics)$cmd_duration"
        "$hostname"
        "$localip"
        "$sudo"
        "$username"
        "$directory"
        "$character"
      ];
    };
  };
}
