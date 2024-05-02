{
  plugins.alpha = let
    nixFlake = [
      "                                 "
      "           ▄ ▄                   "
      "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     "
      "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     "
      "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     "
      "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  "
      "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄"
      "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █"
      "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █"
      "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    "
    ];
  in {
    enable = true;
    layout = [
      {
        type = "padding";
        val = 4;
      }
      {
        opts = {
          hl = "AlphaHeader";
          position = "center";
        };
        type = "text";
        val = nixFlake;
      }
      {
        type = "padding";
        val = 2;
      }
      {
        type = "group";
        val = let
          mkButton = shortcut: cmd: val: hl: {
            type = "button";
            inherit val;
            opts = {
              inherit hl shortcut;
              keymap = [
                "n"
                shortcut
                cmd
                {}
              ];
              position = "center";
              cursor = 0;
              width = 40;
              align_shortcut = "right";
              hl_shortcut = "Keyword";
            };
          };
        in [
          (
            mkButton
            "<c-n>"
            "<CMD>NvimTreeToggle<CR>"
            " Open File Browser"
            "Operator"
          )
          (
            mkButton
            "ff"
            "<CMD>lua require('telescope.builtin').find_files({hidden = true})<CR>"
            " Find File"
            "Operator"
          )
          (
            mkButton
            "fg"
            "<CMD>lua require('telescope.builtin').oldfiles({hidden = true})<CR>"
            "󰈚 Recent File"
            "Operator"
          )
          (
            mkButton
            "fr"
            "<CMD>lua require('telescope.builtin').live_grep({hidden = true})<CR>"
            "󰈭 Find Word"
            "Operator"
          )
        ];
      }
      {
        type = "padding";
        val = 2;
      }
      {
        opts = {
          hl = "GruvboxBlue";
          position = "center";
        };
        type = "text";
        val = "https://github.com/Multipixelone/nix-laptop";
      }
    ];
  };
}
