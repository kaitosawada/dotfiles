{ pkgs, ... }:
let
  accelerated-jk = pkgs.vimUtils.buildVimPlugin {
    name = "accelerated-jk";
    src = pkgs.fetchFromGitHub {
      owner = "rainbowhxch";
      repo = "accelerated-jk.nvim";
      rev = "8fb5dad4ccc1811766cebf16b544038aeeb7806f";
      hash = "sha256-zpjqCARlQU6g50s8wpaqN9xFK4tdUbrxU6MJrQZfSA8=";
    };
  };
in
{
  extraConfigLua = ''
    require('accelerated-jk').setup({

    });
  '';

  extraPlugins = [
    accelerated-jk
  ];

  keymaps = [
    {
      mode = [ "n" ];
      key = "j";
      action = "<Plug>(accelerated_jk_gj)";
      options = {
        desc = "accelerated-jk: Move down";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = [ "n" ];
      key = "k";
      action = "<Plug>(accelerated_jk_gk)";
      options = {
        desc = "accelerated-jk: Move up";
        noremap = true;
        silent = true;
      };
    }
  ];
}
