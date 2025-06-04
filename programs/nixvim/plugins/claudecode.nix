{ pkgs, ... }:
let
  claudecode = pkgs.vimUtils.buildVimPlugin {
    name = "claudecode";
    src = pkgs.fetchFromGitHub {
      owner = "coder";
      repo = "claudecode.nvim";
      rev = "c1cdcd5a61d5a18f262d5c8c53929e3a27cb7821";
      hash = "sha256-oWUO9DfckZuFXmMcW3Y/gEF2EbFD/lE2Vt2YzANkrWo=";
    };
  };
in
{
  extraConfigLua = ''
    require('claudecode').setup({});
  '';

  extraPlugins = [
    claudecode
  ];

  keymaps = [

    {
      mode = [ "n" ];
      key = "<leader>r";
      action = "<cmd>ClaudeCode<cr>";
      options = {
        desc = "claudecode: Toggle";
        noremap = true;
        silent = true;
      };
    }
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
    #     "t"
    #   ];
    #   key = "<F7>";
    #   action = "<C-\\><C-n><Plug>(skkeleton-enable)";
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
    #     "t"
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
    #     "t"
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
