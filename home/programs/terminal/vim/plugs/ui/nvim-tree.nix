{
  plugins.nvim-tree = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>NvimTreeFocus<cr>";
      options = {
        desc = "Focus Nvim-Tree";
      };
    }
  ];
}
