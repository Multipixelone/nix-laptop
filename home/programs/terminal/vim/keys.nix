{
  globals.mapleader = " ";
  keymaps = [
    {
      mode = "n";
      key = "<c-s>";
      action = "<cmd>w<CR>";
      options = {
        desc = "Save File";
      };
    }
    {
      mode = "n";
      key = "<c-k>";
      action = "<cmd>ObsidianSearch<CR>";
      options = {
        desc = "Obsidian Grep";
      };
    }
  ];
}
