{
  imports = [
    ./avante.nix
    ./bufferline.nix
    ./flash.nix
    ./lualine.nix
    ./nvim-tree.nix
    ./obsidian.nix
    ./lazygit.nix
    ./lsp.nix
    ./skkeleton.nix
    ./telescope.nix
    ./treesitter.nix
  ];

  plugins = {
    auto-save.enable = true;
    auto-session.enable = true;
    copilot-vim.enable = true;
    fidget.enable = true;
    gitsigns.enable = true;
    lsp-signature.enable = true;
    nvim-surround.enable = true;
    todo-comments.enable = true;
    wakatime.enable = true;
    which-key.enable = true;

    # for avante.lazyLoad
    lz-n.enable = true;
    web-devicons.enable = true;
  };
}
