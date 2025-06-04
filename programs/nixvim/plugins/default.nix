{
  imports = [
    ./alpha.nix
    ./bufferline.nix
    ./cmp.nix
    ./claudecode.nix
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
    # core
    auto-save.enable = true;
    copilot-vim.enable = true;

    # view
    lsp-signature.enable = true;
    gitsigns.enable = true;
    dressing = {
      enable = true;
      settings.input.enabled = false;
    };
    noice.enable = true;
    todo-comments.enable = true;
    render-markdown.enable = true;
    image = {
      enable = true;
      settings = {
        backend = "kitty";
      };
    };

    # tools
    nvim-surround.enable = true;
    which-key.enable = true;

    # integrations
    wakatime.enable = true;

    # for avante.lazyLoad
    lz-n.enable = true;
    web-devicons.enable = true;
  };
}
