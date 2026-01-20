{
  globals.mapleader = " ";

  opts = {
    laststatus = 3;
    expandtab = true;
    number = true;
    shiftwidth = 2;
    tabstop = 2;
    termguicolors = true;
  };

  keymaps = [
    {
      mode = "i";
      key = "jj";
      action = "<Esc>";
      options.silent = true;
    }
    {
      mode = [
        "n"
        "v"
      ];
      key = "gy";
      action = "\"*y";
      options.silent = true;
    }
  ];

  userCommands = {
    "Q".command = "q";
    "Wq".command = "wq";
  };

  extraConfigLua = ''
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
  '';
}
