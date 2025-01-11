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
in
{
  extraConfigLua = ''
    vim.fn["skkeleton#register_kanatable"]("rom", { jj = "escape" })
    vim.fn["skkeleton#config"]({
      globalDictionaries = {
        "${skkDict}/SKK-JISYO.L"
      }
    })
  '';

  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "denops.vim";
      src = pkgs.fetchFromGitHub {
        owner = "vim-denops";
        repo = "denops.vim";
        rev = "4ff8f353ee54ee67288c1099242444ccb0ab5b69";
        hash = "sha256-kqvNcCX4wlvb8BVrSF+WD5uGY8zHaS2mp75y8tenMnk=";
      };
    })
    (pkgs.vimUtils.buildVimPlugin {
      name = "skkeleton";
      src = pkgs.fetchFromGitHub {
        owner = "vim-skk";
        repo = "skkeleton";
        rev = "8bb1b8782227291c8cbe2aa62a9af732557690cc";
        hash = "sha256-V86J+8rg1/5ZUL9t0k2S5H+z7KZ1DZwLwmb5yM0+vts=";
      };
    })
  ];

  keymaps = [
    {
      mode = [
        "i"
        "n"
        "c"
      ];
      key = "<C-,>";
      action = "<Plug>(skkeleton-toggle)";
      options = {
        desc = "skkeleton: Enable";
        noremap = true;
        silent = true;
      };
    }
  ];
}
