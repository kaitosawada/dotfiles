{
  plugins.bufferline.enable = true;
  keymaps = [
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
  ];
}
