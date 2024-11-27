{
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>f" = "find_files";
      "<leader>g" = "live_grep";
      "<leader>td" = "resume";
      # vim.keymap.set('n', '<leader>tb', builtin.buffers, opts("Buffers"))
      # vim.keymap.set('n', '<leader>th', builtin.help_tags, opts("Help Tags"))
      # vim.keymap.set('n', '<leader>tr', builtin.registers, opts("Registers"))
      # vim.keymap.set('n', '<leader>tc', builtin.commands, opts("Commands"))
    };
  };
}
