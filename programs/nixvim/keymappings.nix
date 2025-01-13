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
      key = "<leader>wj";
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
      action = "<C-w>p";
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
      action = ":execute '!open ' . shellescape(expand('<cfile>'); 1)<CR>";
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
      key = "<leader>-";
      action = "<CMD>vsplit<CR>";
      options = {
        desc = "縦に分割";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>|";
      action = "<CMD>split<CR>";
      options = {
        desc = "横に分割";
        noremap = true;
        silent = true;
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
      action = "\"0p";
      options = {
        desc = "Close tabs which you picked";
        noremap = false;
        silent = false;
      };
    }
  ];
}
