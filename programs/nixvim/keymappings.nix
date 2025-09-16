{ helpers, ... }:
{
  keymaps = [
    {
      mode = [
        "n"
        "v"
        "o"
      ];
      key = "<C-a>";
      action = "<CMD>qall<CR>";
      options = {
        desc = "Close all tabs";
        noremap = true;
        silent = true;
      };
    }
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
      mode = "n";
      key = "<Right>";
      action = "<C-w>w";
      options = {
        desc = "Next Window";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = "n";
      key = "<Left>";
      action = "<C-w>W";
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
      action = helpers.mkRaw ''
        function()
          local target = vim.fn.expand("<cfile>")
          if target == nil or target == "" then
            vim.notify("カーソル下に対象がありません", vim.log.levels.WARN)
            return
          end

          if target:match("^https?://") then
            -- OSごとに既定ハンドラで開く
            if vim.fn.has("mac") == 1 then
              vim.fn.jobstart({ "open", target }, { detach = true })
            elseif vim.fn.has("unix") == 1 then
              vim.fn.jobstart({ "xdg-open", target }, { detach = true })
            elseif vim.fn.has("win32") == 1 then
              vim.fn.jobstart({ "cmd", "/c", "start", "", target }, { detach = true })
            else
              vim.notify("未対応OSです", vim.log.levels.ERROR)
            end
          else
            vim.cmd("edit " .. vim.fn.fnameescape(target))
          end
        end
      '';
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
    # terminalからnormalモードに戻る
    {
      mode = "t";
      key = "<C-\\>";
      action = "<C-\\><C-n>";
      options = {
        desc = "Terminal to Normal Mode";
        noremap = true;
        silent = true;
      };
    }
  ];
}
