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
      key = "<leader>sv";
      action = "<CMD>vsplit<CR>";
      options = {
        desc = "縦に分割";
        noremap = true;
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>sh";
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
      key = "-";
      action = "<CMD>NvimTreeFindFile<CR>";
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
      key = "<leader>wl";
      action = "<CMD>BufferLineCloseRight<CR>";
      options = {
        desc = "Close right tabs";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>wh";
      action = "<CMD>BufferLineCloseLeft<CR>";
      options = {
        desc = "Close left tabs";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>wa";
      action = "<CMD>BufferLineCloseOthers<CR>";
      options = {
        desc = "Close all tabs without current tab";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "<leader>we";
      action = "<CMD>BufferLinePickClose<CR>";
      options = {
        desc = "Close tabs which you picked";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "gb";
      action = "<CMD>BufferLinePick<CR>";
      options = {
        desc = "Pick a buffer";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "<C-S-l>";
      action = "<CMD>BufferLineCycleNext<CR>";
      options = {
        desc = "Cycle to next buffer";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "<C-S-h>";
      action = "<CMD>BufferLineCyclePrev<CR>";
      options = {
        desc = "Cycle to previous buffer";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "<S-l>";
      action = "<CMD>BufferLineCycleNext<CR>";
      options = {
        desc = "Cycle to next buffer";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "<S-h>";
      action = "<CMD>BufferLineCyclePrev<CR>";
      options = {
        desc = "Cycle to previous buffer";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "]b";
      action = "<CMD>BufferLineMoveNext<CR>";
      options = {
        desc = "Move buffer to next position";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "[b";
      action = "<CMD>BufferLineMovePrev<CR>";
      options = {
        desc = "Move buffer to previous position";
        noremap = false;
        silent = false;
      };
    }
    {
      mode = [ "n" ];
      key = "gs";
      action = "<CMD>BufferLineSortByDirectory<CR>";
      options = {
        desc = "Sort buffers by directory";
        noremap = false;
        silent = false;
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
    {
      mode = ["n"];
      key = "gx";
      action = ":execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>";
      options = {
        desc = "リンクを開く";
        noremap = true;
        silent = true;
      };
    }
  ];
}
