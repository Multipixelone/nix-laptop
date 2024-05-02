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
  ];
}
