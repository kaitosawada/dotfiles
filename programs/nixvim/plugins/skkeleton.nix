{ pkgs, ... }:
let
  inherit (import ../../../lib/skkeleton.nix { inherit pkgs; }) skkDict;

  denops = pkgs.vimUtils.buildVimPlugin {
    name = "denops.vim";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops.vim";
      rev = "5cfca39988a36e42d81b925264fc846077a727e3";
      hash = "sha256-4AACZ3h6uAqiXW24gUF1+uq7dnWA0w/PcxAeO4yxitc=";
    };
  };

  skkeleton = pkgs.vimUtils.buildVimPlugin {
    name = "skkeleton";
    src = pkgs.fetchFromGitHub {
      owner = "vim-skk";
      repo = "skkeleton";
      rev = "71178b6debd9f1b3bb00abfd865ca642e82e24c7";
      hash = "sha256-833WpBi0X6MhblLda1cp6dFU2zu+TYBgimlsBX+3rQo=";
    };
  };

  # build時にテストが失敗するので除外
  skkeleton_indicator =
    (pkgs.vimUtils.buildVimPlugin {
      name = "skkeleton_indicator";
      src = pkgs.fetchFromGitHub {
        owner = "delphinus";
        repo = "skkeleton_indicator.nvim";
        rev = "f08532787cf842b996c8a5065be7e85cd3376c1f";
        hash = "sha256-6pQdj7EcPZ5/F34Y6SERRxcgKO6KLVH/94Th78ucn2Y=";
      };
    }).overrideAttrs
      (oldAttrs: {
        neovimRequireCheckHook = ''
          rm lua/skkeleton_indicator/strings.test.lua
          ${oldAttrs.neovimRequireCheckHook or ""}
        '';
      });
in
{
  extraConfigLua = ''
    vim.fn["skkeleton#register_kanatable"]("rom", { jj = "escape" })
    vim.fn["skkeleton#config"]({
      eggLikeNewline = true,
      globalDictionaries = { "${skkDict}/SKK-JISYO.L" }
    })
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
