{ pkgs, ... }:
let
  no-neck-pain = pkgs.vimUtils.buildVimPlugin {
    name = "no-neck-pain";
    src = pkgs.fetchFromGitHub {
      owner = "shortcuts";
      repo = "no-neck-pain.nvim";
      rev = "860462dd8b3d36861a81724a7b473db279f673f2";
      hash = "sha256-n1psdgFd7mvqG8fQU/ZRj84/gKxJHFluzMcOhWJsYNs=";
    };
  };
in
{
  extraConfigLua = ''
    require("no-neck-pain").setup({
      autocmds = {
        eneblaOnVimEnter = true,
        skipEnteringNoNeckPainBuffer = true,
      },
    })
  '';

  extraPlugins = [
    no-neck-pain
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
