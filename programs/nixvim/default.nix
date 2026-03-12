{
  imports = [
    ./config.nix
    ./plugins
    ./keymappings.nix
    ./theme.nix
  ];
  enable = true;

  extraConfigLua = ''
    -- ファイルの外部変更を自動的に読み込む
    vim.opt.autoread = true

    -- フォーカスを得た時、バッファに入った時に自動読み込みをチェック（ターミナルバッファを除外）
    vim.api.nvim_create_autocmd({"FocusGained", "BufEnter"}, {
      pattern = "*",
      callback = function()
        if vim.bo.buftype ~= "terminal" then
          vim.cmd("silent! checktime")
        end
      end
    })

    -- ファイルが変更された時の通知（オプション）
    vim.api.nvim_create_autocmd("FileChangedShell", {
      pattern = "*",
      command = "echo 'Warning: File changed on disk'"
    })
  '';
}
