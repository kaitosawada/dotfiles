{ pkgs, ... }:
let
  skkDict = pkgs.stdenv.mkDerivation {
    name = "skk-jisyo";
    src = pkgs.fetchurl {
      url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
      sha256 = "sha256-QjbhriumZ1IJIvxapAb3fY4w81kEIdNPQfRq9kG7SKo=";
    };
    phases = [
      "unpackPhase"
      "installPhase"
    ];
    unpackPhase = ''
      gzip -d $src -c > SKK-JISYO.L
    '';
    installPhase = ''
      mkdir -p $out
      mv SKK-JISYO.L $out
    '';
  };

  denops = pkgs.vimUtils.buildVimPlugin {
    name = "denops.vim";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops.vim";
      rev = "4ff8f353ee54ee67288c1099242444ccb0ab5b69";
      hash = "sha256-kqvNcCX4wlvb8BVrSF+WD5uGY8zHaS2mp75y8tenMnk=";
    };
  };
  skkeleton = pkgs.vimUtils.buildVimPlugin {
    name = "skkeleton";
    src = pkgs.fetchFromGitHub {
      owner = "vim-skk";
      repo = "skkeleton";
      rev = "8bb1b8782227291c8cbe2aa62a9af732557690cc";
      hash = "sha256-V86J+8rg1/5ZUL9t0k2S5H+z7KZ1DZwLwmb5yM0+vts=";
    };
  };
  # build時にテストが失敗するので除外
  skkeleton_indicator =
    (pkgs.vimUtils.buildVimPlugin {
      name = "skkeleton_indicator";
      src = pkgs.fetchFromGitHub {
        owner = "delphinus";
        repo = "skkeleton_indicator.nvim";
        rev = "d9b649d734ca7d3871c4f124004771d0213dc747";
        hash = "sha256-xr2yTHsGclLvXPpRNYBFS+dIB0+RNUb27TlGq5apBig=";
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
      globalDictionaries = {
        "${skkDict}/SKK-JISYO.L"
      }
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
      key = "<C-u>";
      action = "<Plug>(skkeleton-enable)";
      options = {
        desc = "skkeleton: Enable";
        noremap = true;
        silent = true;
      };
    }
  ];
}
