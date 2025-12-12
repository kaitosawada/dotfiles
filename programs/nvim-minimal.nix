{ pkgs, ... }:
let
  skkPkgs = import ../lib/skkeleton.nix { inherit pkgs; };
  inherit (skkPkgs) denops skkeleton skkeleton_indicator skkeletonConfigLua;

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
        ${skkeletonConfigLua}

        -- キーマップ
        vim.keymap.set({"i", "n", "c"}, "<F7>", "<Plug>(skkeleton-enable)", { noremap = true, silent = true })
        vim.keymap.set({"i", "n", "c"}, "<F6>", "<Plug>(skkeleton-disable)", { noremap = true, silent = true })
        vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })

        -- 外部クリップボード連携
        vim.keymap.set({"n", "v"}, "gy", "\"*y", { noremap = true, silent = true })
        vim.g.clipboard = {
          name = "OSC 52",
          copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
          },
          paste = {
            ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
            ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
          },
        }


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
