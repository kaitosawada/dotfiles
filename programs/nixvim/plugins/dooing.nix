{ pkgs, ... }:
let
  dooing = pkgs.vimUtils.buildVimPlugin {
    name = "dooing";
    src = pkgs.fetchFromGitHub {
      owner = "atiladefreitas";
      repo = "dooing";
      rev = "fa55fb5aa889f5d84095a8fa2a1a2c7f08f31289";
      hash = "sha256-E4QVGPbH+24+BzB7p2e+kzJylCcz6PBYCY68/hAOEow=";
    };
  };
in
{
  extraConfigLua = ''
    require("dooing").setup()
  '';

  extraPlugins = [
    dooing
  ];

  keymaps = [
    # {
    #   mode = [
    #     "i"
    #     "n"
    #     "c"
    #   ];
    #   key = "<F7>";
    #   action = "<Plug>(skkeleton-enable)";
    #   options = {
    #     desc = "skkeleton: Enable";
    #     noremap = true;
    #     silent = true;
    #   };
    # }
    # {
    #   mode = [
    #     "i"
    #     "n"
    #     "c"
    #   ];
    #   key = "<C-u>";
    #   action = "<Plug>(skkeleton-enable)";
    #   options = {
    #     desc = "skkeleton: Enable";
    #     noremap = true;
    #     silent = true;
    #   };
    # }
    # {
    #   mode = [
    #     "i"
    #     "n"
    #     "c"
    #   ];
    #   key = "<F6>";
    #   action = "<Plug>(skkeleton-disable)";
    #   options = {
    #     desc = "skkeleton: Disable";
    #     noremap = true;
    #     silent = true;
    #   };
    # }
  ];
}
