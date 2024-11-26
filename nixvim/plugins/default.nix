{
  imports = [
    ./lualine.nix
    ./nvim-tree.nix
    ./lazygit.nix
    ./lsp.nix
  ];
  plugins = {
    auto-save.enable = true;
    auto-session.enable = true;
    bufferline.enable = true;
    leap.enable = true;
    gitsigns.enable = true;
    nvim-surround.enable = true;
    todo-comments.enable = true;
    which-key.enable = true;
    telescope = {
      enable = true;
      keymaps = {
        "<leader>f" = {
          action = "find_files";
          options = {
            desc = "Find project files";
          };
        };
        "<leader>g" = {
          action = "live_grep";
          options = {
            desc = "Grep (root dir)";
          };
        };
        "<leader>td" = {
          action = "resume";
          options = {
            desc = "Resume last";
          };
        };
        # vim.keymap.set('n', '<leader>tb', builtin.buffers, opts("Buffers"))
        # vim.keymap.set('n', '<leader>th', builtin.help_tags, opts("Help Tags"))
        # vim.keymap.set('n', '<leader>tr', builtin.registers, opts("Registers"))
        # vim.keymap.set('n', '<leader>tc', builtin.commands, opts("Commands"))
        # vim.keymap.set('n', '<leader>td', ':Telescope resume<CR>', opts("Resume Last"))
      };
    };
    web-devicons.enable = true;
  };
}
