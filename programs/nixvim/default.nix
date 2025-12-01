{
  pkgs,
  ...
}:
{
  imports = [
    ./plugins
    ./keymappings.nix
    ./theme.nix
  ];
  enable = true;

  # neovim内部でのみnodejsにパスを通す（zshの$PATHには影響しない）
  extraPackages = with pkgs; [
    nodejs
  ];

  globals.mapleader = " ";

  opts = {
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    number = true;
    laststatus = 3;
  };

  userCommands = {
    "Wq" = {
      command = "wq";
    };
    "Q" = {
      command = "q";
    };
  };

  # extraConfigLuaPre = builtins.readFile lua/bitwarden.lua;
  extraConfigLua = ''
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }

    -- ファイルの外部変更を自動的に読み込む
    vim.opt.autoread = true

    -- フォーカスを得た時、バッファに入った時に自動読み込みをチェック
    vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
      pattern = "*",
      command = "silent! checktime"
    })

    vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
      pattern = "*",
      command = "checktime"
    })

    -- ファイルが変更された時の通知（オプション）
    vim.api.nvim_create_autocmd("FileChangedShell", {
      pattern = "*",
      command = "echo 'Warning: File changed on disk'"
    })
  '';
}
