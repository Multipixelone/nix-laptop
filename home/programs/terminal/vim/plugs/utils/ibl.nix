{
  plugins.indent-blankline = {
    enable = true;
    settings = {
      indent = {
        char = "│";
      };
      scope = {
        show_start = false;
        show_end = false;
        show_exact_scope = true;
      };
      exclude = {
        filetypes = [
          "help"
          "alpha"
          "dashboard"
          "neo-tree"
          "Trouble"
          "trouble"
          "lazy"
          "notify"
          "toggleterm"
          "lazyterm"
          "lspinfo"
          "packer"
          "checkhealth"
          "help"
          "man"
          "gitcommit"
          "TelescopePrompt"
          "TelescopeResults"
          "\'\'"
        ];
        buftypes = ["terminal" "quickfix"];
      };
    };
  };
}
