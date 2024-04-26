{
  plugins.lsp = {
    enable = true;

    servers = {
      tsserver.enable = true;
      nil_ls.enable = true;
      marksman.enable = true;
      yamlls.enable = true;

      lua-ls = {
        enable = true;
        settings.telemetry.enable = false;
      };
      rust-analyzer = {
        enable = true;
        installCargo = true;
        installRustc = true;
      };
    };
  };
  plugins.nvim-autopairs.enable = true;
}
