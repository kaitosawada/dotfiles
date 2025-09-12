{ pkgs, ... }:
let
  tsc-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tsc";
    src = pkgs.fetchFromGitHub {
      owner = "dmmulroy";
      repo = "tsc.nvim";
      rev = "5bd25bb5c399b6dc5c00392ade6ac6198534b53a";
      hash = "sha256-X38USrIZUJNlR46Y3vWwYW5VFiIWsxhb+qcFciqhh+g=";
    };

    doCheck = false;

    dependencies = [ pkgs.typescript ];
  };
in
{
  extraConfigLua = ''
    require('tsc').setup({
      flags = "-b",
    });
  '';

  extraPlugins = [
    tsc-nvim
  ];

  # keymaps = [
  #   {
  #     mode = [ "n" ];
  #     key = "j";
  #     action = "<Plug>(accelerated_jk_gj)";
  #     options = {
  #       desc = "accelerated-jk: Move down";
  #       noremap = true;
  #       silent = true;
  #     };
  #   }
  #   {
  #     mode = [ "n" ];
  #     key = "k";
  #     action = "<Plug>(accelerated_jk_gk)";
  #     options = {
  #       desc = "accelerated-jk: Move up";
  #       noremap = true;
  #       silent = true;
  #     };
  #   }
  # ];
}
