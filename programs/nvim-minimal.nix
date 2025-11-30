{ pkgs, ... }:
let
  # SKK辞書
  skkDict = pkgs.stdenv.mkDerivation {
    name = "skk-jisyo";
    src = pkgs.fetchurl {
      url = "https://skk-dev.github.io/dict/SKK-JISYO.L.gz";
      sha256 = "sha256-QjbhriumZ1IJIvxapAb3fY4w81kEIdNPQfRq9kG7SKo=";
    };
    phases = [ "unpackPhase" "installPhase" ];
    unpackPhase = "gzip -d $src -c > SKK-JISYO.L";
    installPhase = "mkdir -p $out && mv SKK-JISYO.L $out";
  };

  # denops.vim
  denops = pkgs.vimUtils.buildVimPlugin {
    name = "denops.vim";
    src = pkgs.fetchFromGitHub {
      owner = "vim-denops";
      repo = "denops.vim";
      rev = "4ff8f353ee54ee67288c1099242444ccb0ab5b69";
      hash = "sha256-kqvNcCX4wlvb8BVrSF+WD5uGY8zHaS2mp75y8tenMnk=";
    };
  };

  # skkeleton
  skkeleton = pkgs.vimUtils.buildVimPlugin {
    name = "skkeleton";
    src = pkgs.fetchFromGitHub {
      owner = "vim-skk";
      repo = "skkeleton";
      rev = "8bb1b8782227291c8cbe2aa62a9af732557690cc";
      hash = "sha256-V86J+8rg1/5ZUL9t0k2S5H+z7KZ1DZwLwmb5yM0+vts=";
    };
  };

  # skkeleton_indicator
  skkeleton_indicator = (pkgs.vimUtils.buildVimPlugin {
    name = "skkeleton_indicator";
    src = pkgs.fetchFromGitHub {
      owner = "delphinus";
      repo = "skkeleton_indicator.nvim";
      rev = "d9b649d734ca7d3871c4f124004771d0213dc747";
      hash = "sha256-xr2yTHsGclLvXPpRNYBFS+dIB0+RNUb27TlGq5apBig=";
    };
  }).overrideAttrs (oldAttrs: {
    neovimRequireCheckHook = ''
      rm lua/skkeleton_indicator/strings.test.lua
      ${oldAttrs.neovimRequireCheckHook or ""}
    '';
  });

  nvim-minimal-unwrapped = pkgs.neovim.override {
    configure = {
      customRC = ''
        lua << EOF
        -- 基本設定
        vim.opt.number = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
        vim.opt.expandtab = true
        vim.opt.termguicolors = true

        -- カラースキーム
        require("nightfox").setup({
          options = { transparent = true },
          groups = { all = { Visual = { bg = "#545c7e" } } }
        })
        vim.cmd("colorscheme duskfox")

        -- skkeleton設定
        vim.fn["skkeleton#register_kanatable"]("rom", { jj = "escape" })
        vim.fn["skkeleton#config"]({
          globalDictionaries = { "${skkDict}/SKK-JISYO.L" }
        })
        vim.fn["skkeleton#register_keymap"]("input", ";", "disable")
        vim.fn["skkeleton#register_keymap"]("input", "l", "henkanPoint")
        require("skkeleton_indicator").setup()

        -- キーマップ
        vim.keymap.set({"i", "n", "c"}, "<F7>", "<Plug>(skkeleton-enable)", { noremap = true, silent = true })
        vim.keymap.set({"i", "n", "c"}, "<F6>", "<Plug>(skkeleton-disable)", { noremap = true, silent = true })
        vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

        -- typo用コマンド
        vim.api.nvim_create_user_command("Wq", "wq", {})
        vim.api.nvim_create_user_command("Q", "q", {})

        -- ファイル末尾でinsertモード開始
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function()
            vim.defer_fn(function()
              vim.cmd("normal! G$")
              vim.cmd("startinsert!")
            end, 10)
          end
        })
        EOF
      '';
      packages.myPlugins = {
        start = [
          pkgs.vimPlugins.nightfox-nvim
          denops
          skkeleton
          skkeleton_indicator
        ];
      };
    };
  };

  nvim-minimal = pkgs.writeShellScriptBin "nvim-minimal" ''
    exec ${nvim-minimal-unwrapped}/bin/nvim "$@"
  '';
in
{
  home.packages = [ nvim-minimal ];
}
