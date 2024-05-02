{
  plugins.illuminate = {
    enable = true;
    underCursor = false;
    providers = ["lsp"];
    filetypesDenylist = [
      "Outline"
      "TelescopePrompt"
      "alpha"
      "harpoon"
      "reason"
    ];
  };
}
