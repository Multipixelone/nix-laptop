{
  plugins.telescope = {
    enable = true;
    extensions = {
      fzf-native = {
        enable = true;
      };
    };
    defaults = {
      layout_config = {
        horizontal = {
          prompt_position = "top";
        };
      };
      sorting_strategy = "ascending";
    };
    keymaps = {
      "<leader>ff" = {
        action = "find_files, {}";
        desc = "Find project files";
      };
    };
  };
}
