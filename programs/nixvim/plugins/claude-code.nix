{ pkgs, lib, ... }:
let
  aider = pkgs.vimUtils.buildVimPlugin {
    name = "claude-code";
    src = pkgs.fetchFromGitHub {
      owner = "greggh";
      repo = "claude-code.nvim";
      rev = "91b38f289c9b1f08007a0443020ed97bb7539ebe";
      hash = "sha256-4H6zu5+iDPnCY+ISsxuL9gtAZ5lJhVvtOscc8jUsAY8=";
    };
  };
in
{
  extraPlugins = [
    aider
  ];

  extraConfigLua = ''
    require("claude-code").setup({
      window = {
        split_ratio = 1.0,
        position = "edit",  -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
        enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
        hide_numbers = true,    -- Hide line numbers in the terminal window
        hide_signcolumn = true, -- Hide the sign column in the terminal window
      },
    })
  '';
}
