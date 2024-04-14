{
  config = {
    colorschemes.catppuccin = {
      enable = true;
      flavour = "mocha";
      transparentBackground = true;
      integrations = {
        cmp = true;
        noice = true;
        notify = true;
        gitsigns = true;
        which_key = true;
        illuminate = {
          enabled = true;
        };
        treesitter = true;
        treesitter_context = true;
        telescope.enabled = true;
        indent_blankline.enabled = true;
        mini.enabled = true;
        native_lsp = {
          enabled = true;
          inlay_hints = {
            background = true;
          };
          underlines = {
            errors = ["underline"];
            hints = ["underline"];
            information = ["underline"];
            warnings = ["underline"];
          };
        };
      };
    };
    opts = {
      number = true;
      tabstop = 2;
      softtabstop = 2;
      showtabline = 2;
      expandtab = true;

      smartindent = true;
      shiftwidth = 2;

      # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
      breakindent = true;

      # Enable incremental searching
      hlsearch = true;
      incsearch = true;

      ignorecase = true;
      smartcase = true;
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m"; # FIgure out what this means LMAO

      showmode = false;
    };
  };
}
