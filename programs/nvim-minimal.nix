{ pkgs, ... }:
let
  skkPkgs = import ../lib/skkeleton.nix { inherit pkgs; };
  inherit (skkPkgs) skkDict denops skkeleton skkeleton_indicator;

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
        vim.keymap.set({"n", "v"}, "gy", "\"*y", { noremap = true, silent = true })

        -- typo用コマンド
        vim.api.nvim_create_user_command("Wq", "wq", {})
        vim.api.nvim_create_user_command("Q", "q", {})

        -- claude-prompt-*.md, *.dump のときファイル末尾でinsertモード開始
        vim.api.nvim_create_autocmd({"VimEnter", "BufReadPost"}, {
          callback = function()
            local filename = vim.fn.expand("%:t")
            if filename:match("^claude%-prompt%-.*%.md$") then
              vim.defer_fn(function()
                vim.cmd("normal! G$")
                vim.cmd("startinsert!")
              end, 10)
            elseif filename:match("%.dump$") then
              vim.defer_fn(function()
                vim.cmd("normal! G0")
                vim.cmd("startinsert")
              end, 10)
            end
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
