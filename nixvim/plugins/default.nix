{
  imports = [
    ./lualine.nix
    ./nvim-tree.nix
    ./lazygit.nix
    ./lsp.nix
    ./telescope.nix
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
    web-devicons.enable = true;
  };
}
