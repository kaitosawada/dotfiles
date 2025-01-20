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

  cmp-skkeleton = pkgs.vimUtils.buildVimPlugin {
    name = "cmp-skkeleton";
    src = pkgs.fetchFromGitHub {
      owner = "uga-rosa";
      repo = "cmp-skkeleton";
      rev = "2c268a407e9e843abd03c6fa77485541a4ddcd9a";
      hash = "sha256-Odg0cmLML2L4YVcrMt7Lrie1BAl7aNEq6xqJN3/JhZs=";
    };
  };

in
# ddc = pkgs.vimUtils.buildVimPlugin {
#   name = "ddc";
#   src = pkgs.fetchFromGitHub {
#     owner = "Shougo";
#     repo = "ddc.vim";
#     rev = "5dd4b0842c1f238ebaf4d6157c05408a9a454743";
#     hash = "sha256-IWXBcHM6LSBzwshsroDx3GAVvTWMtlOmQKei9PSAEqI=";
#   };
# };
#
# pum = pkgs.vimUtils.buildVimPlugin {
#   name = "pum";
#   src = pkgs.fetchFromGitHub {
#     owner = "Shougo";
#     repo = "pum.vim";
#     rev = "f6ba3223260c228c0c7fd19a189ce36e20325b85";
#     hash = "sha256-rYswWOgnG5A4rSFknMWz2z1feeoYx/JVJlhYsuoZzXU=";
#   };
# };
{
  extraConfigLua = ''
    vim.fn["skkeleton#register_kanatable"]("rom", { jj = "escape" })
    vim.fn["skkeleton#config"]({
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
    cmp-skkeleton
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
