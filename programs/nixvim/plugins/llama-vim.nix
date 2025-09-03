{ pkgs, ... }:
let
  llama-vim = pkgs.vimUtils.buildVimPlugin {
    name = "llama.vim";
    src = pkgs.fetchFromGitHub {
      owner = "ggml-org";
      repo = "llama.vim";
      rev = "c31cd096eac44fee7e436ce34e8beed4b3c6befa";
      hash = "sha256-MGVg5OpCJEzwOrnfy2IZl2+1nsDl7VGhOrS0zFKHYSo=";
    };
  };
in
{
  extraConfigLua = ''
    vim.g.llama_config = {
      auto_fim = true,
      show_info = 2,
    }
  '';

  extraPlugins = [
    llama-vim
  ];
}
