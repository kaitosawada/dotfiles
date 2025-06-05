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
    {
      mode = [
        "n"
        "v"
      ];
      key = ";";
      action = ":";
      options = {
        desc = "Command Mode";
        noremap = true;
        silent = true;
      };
    }
  ];
}
