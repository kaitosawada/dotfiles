{ pkgs, ... }:
let
  skkPkgs = import ../../../lib/skkeleton.nix { inherit pkgs; };
  inherit (skkPkgs) denops skkeleton skkeleton_indicator skkeletonConfigLua;
in
{
  extraConfigLua = skkeletonConfigLua;

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
