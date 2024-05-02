{
  plugins.lsp = {
    enable = true;

    servers = {
      eslint = {enable = true;};
      html = {enable = true;};
      lua-ls = {enable = true;};
      nil_ls = {enable = true;};
      marksman = {enable = true;};
      pyright = {enable = true;};
      gopls = {enable = true;};
      terraformls = {enable = true;};
      tsserver = {enable = false;};
      yamlls = {
        enable = true;
      };
      rust-analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };
    };
  };
  extraConfigLua = ''
    local _border = "rounded"

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = _border
      }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = _border
      }
    )

    vim.diagnostic.config{
      float={border=_border}
    };

    require('lspconfig.ui.windows').default_options = {
      border = _border
    }
  '';
  plugins.trouble = {
    enable = true;
  };
  plugins.lspkind = {
    enable = true;
    symbolMap = {
      Copilot = "";
    };
    extraOptions = {
      maxwidth = 50;
      ellipsis_char = "...";
    };
  };
}
