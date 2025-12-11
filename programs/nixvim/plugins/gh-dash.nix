{
  keymaps = [
    {
      mode = "n";
      key = "<leader>d";
      action.__raw = ''
        function()
          -- フローティングウィンドウのサイズ計算
          local width = math.floor(vim.o.columns * 0.9)
          local height = math.floor(vim.o.lines * 0.9)
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)

          -- バッファとウィンドウ作成
          local buf = vim.api.nvim_create_buf(false, true)
          local win = vim.api.nvim_open_win(buf, true, {
            relative = "editor",
            width = width,
            height = height,
            row = row,
            col = col,
            style = "minimal",
            border = "rounded",
          })

          -- gh-dashをターミナルで起動
          vim.fn.termopen("gh dash", {
            on_exit = function()
              if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
              end
            end,
          })

          vim.cmd("startinsert")

          -- ESCでターミナルを閉じる（qはgh-dash自体が処理→on_exitで自動クローズ）
          vim.keymap.set("t", "<ESC>", function()
            vim.api.nvim_win_close(win, true)
          end, { buffer = buf })
        end
      '';
      options = {
        desc = "Open gh-dash";
        noremap = true;
        silent = true;
      };
    }
  ];
}
