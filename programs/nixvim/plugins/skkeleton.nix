{ pkgs, ... }:
let
  skkPkgs = import ../../../lib/skkeleton.nix { inherit pkgs; };
  inherit (skkPkgs) skkDict denops skkeleton skkeleton_indicator;
in
{
  extraConfigLua = ''
    vim.fn["skkeleton#register_kanatable"]("rom", { jj = "escape" })
    vim.fn["skkeleton#config"]({
      eggLikeNewline = true,
      globalDictionaries = {
        "${skkDict}/SKK-JISYO.L"
      }
    })

    vim.fn["skkeleton#register_keymap"]('input', ";", 'disable')
    vim.fn["skkeleton#register_keymap"]('input', "l", 'henkanPoint')
    require("skkeleton_indicator").setup()
  '';

  extraPlugins = [
    denops
    skkeleton
    skkeleton_indicator
  ];

  keymaps = [
    {
      mode = [
        "i"
        "n"
        "c"
      ];
      key = "<F7>";
      action = "<Plug>(skkeleton-enable)";
      options = {
        desc = "skkeleton: Enable";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = [
        "i"
        "n"
        "c"
      ];
      key = "<F6>";
      action = "<Plug>(skkeleton-disable)";
      options = {
        desc = "skkeleton: Disable";
        noremap = true;
        silent = true;
      };
    }
  ];
}
