{
  plugins.nvim-tree = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "<c-n>";
      action = "<cmd>NvimTreeToggle<cr>";
      options = {
        desc = "Toggle Nvim-Tree";
      };
    }
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
