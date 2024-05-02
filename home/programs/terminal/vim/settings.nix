{
  config = {
    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparentBackground = false;
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
    };
    clipboard = {
      register = "unnamedplus";
      providers = {wl-copy = {enable = true;};};
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

      # Mouse
      mouse = "a";

      # Enable incremental searching
      hlsearch = true;
      incsearch = true;

      ignorecase = true;
      smartcase = true;
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m"; # FIgure out what this means LMAO

      showmode = false;
      termguicolors = true;
      conceallevel = 1;
      listchars = {
        tab = "󰌒 ";
        trail = "•";
        nbsp = "␣";
      };

      # Folding stuff
      foldmethod = "expr";
      foldnestmax = 20;
      foldminlines = 2;
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
      foldexpr = "nvim_treesitter#foldexpr()";
    };
  };
}
