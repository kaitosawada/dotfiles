{ pkgs, ... }:
{
  imports = [
    ./lualine.nix
    ./nvim-tree.nix
    ./obsidian.nix
    ./lazygit.nix
    ./lsp.nix
    ./telescope.nix
    ./treesitter.nix
  ];
  plugins = {
    auto-save.enable = true;
    auto-session.enable = true;
    bufferline.enable = true;
    copilot-vim.enable = true;
    leap.enable = true;
    # fidget-nvim.enable = true;
    glow.enable = true;
    gitsigns.enable = true;
    nvim-surround.enable = true;
    todo-comments.enable = true;
    wakatime.enable = true;
    which-key.enable = true;
    web-devicons.enable = true;
  };
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "denops.vim";
      src = pkgs.fetchFromGitHub {
        owner = "vim-denops";
        repo = "denops.vim";
        rev = "4ff8f353ee54ee67288c1099242444ccb0ab5b69";
        hash = "sha256-kqvNcCX4wlvb8BVrSF+WD5uGY8zHaS2mp75y8tenMnk=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "skkeleton";
      src = pkgs.fetchFromGitHub {
        owner = "vim-skk";
        repo = "skkeleton";
        rev = "8bb1b8782227291c8cbe2aa62a9af732557690cc";
        hash = "sha256-kqvNcCX4wlvb8BVrSF+WD5uGY8zHaS2mp75y8tenMnk=";
      };
    })
  ];
}
