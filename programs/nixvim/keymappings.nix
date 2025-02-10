{
  keymaps = [
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "<Up>";
      action = "<C-u>zz";
      options = {
        desc = "Up half page";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "<Down>";
      action = "<C-d>zz";
      options = {
        desc = "Down half page";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "(";
      action = "(zz";
      options = {
        desc = "Up half page";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "(";
      action = "(zz";
      options = {
        desc = "Down half page";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = "n";
      key = "<leader>j";
      action = "<C-w>w";
      options = {
        desc = "Next Window";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = "n";
      key = "<leader>wk";
      action = "<C-w>k";
      options = {
        desc = "Previous Window";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "gp";
      action = "0p";
      options = {
        desc = "Paste from yank register";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "gP";
      action = "0P";
      options = {
        desc = "Paste from yank register";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = "n";
      key = "gx";
      action = ":execute '!open ' . shellescape(expand('<cfile>'))<CR>";
      options = {
        desc = "リンクを開く";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "i";
      key = "jj";
      action = "<ESC>";
      options = {
        desc = "ノーマルモードに戻る";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<CMD>vsplit<CR>";
      options = {
        desc = "縦に分割";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>-";
      action = "<CMD>split<CR>";
      options = {
        desc = "横に分割";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "gy";
      action = "\"*y";
      options = {
        desc = "Close tabs which you picked";
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "gp";
      action = "\"0p";
      options = {
        desc = "Close tabs which you picked";
      };
    }
    # https://github.com/fresh2dev/zellij-autolock?tab=readme-ov-file
    # zellijとシームレスに移動する
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "<C-j>";
      action.__raw = ''
        function()
          local function get_last_focusable_winnr()
            local last_winnr = vim.fn.winnr('$')
            for i = last_winnr, 1, -1 do
              local win_id = vim.fn.win_getid(i)
              if vim.api.nvim_win_get_config(win_id).focusable ~= false then
                return i
              end
            end
            return 0  -- focusableなウィンドウが見つからない場合
          end

          local current = vim.fn.winnr()
          local last = get_last_focusable_winnr()

          -- 次のウィンドウが存在し、フォーカス可能な場合
          if current < last then
            vim.cmd('wincmd w')
          else
            vim.cmd('wincmd 1 w')
            -- 最後のウィンドウの場合はzellijコマンドを実行
            vim.fn.system('zellij action focus-next-pane')
          end
        end
      '';
      options = {
        desc = "Debug window info";
        noremap = false;
        silent = false;
      };
    }
    # zellijとシームレスに移動する
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "<C-k>";
      action.__raw = ''
        function()
          local function get_first_focusable_winnr()
            local last_winnr = vim.fn.winnr('$')
            for i = 1, last_winnr, 1 do
              local win_id = vim.fn.win_getid(i)
              if vim.api.nvim_win_get_config(win_id).focusable ~= false then
                return i
              end
            end
            return 0  -- focusableなウィンドウが見つからない場合
          end

          local current = vim.fn.winnr()
          local first = get_first_focusable_winnr()

          -- 前のウィンドウが存在し、フォーカス可能な場合
          if first < current then
            vim.cmd('wincmd W')
          else
            -- 最初のウィンドウの場合はzellijコマンドを実行
            vim.fn.system('zellij action focus-previous-pane')
          end
        end
      '';
      options = {
        desc = "Debug window info";
        noremap = false;
        silent = false;
      };
    }
  ];
}
