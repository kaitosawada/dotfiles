{
  globals.mapleader = " ";

  opts = {
    background = "dark";
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

    -- Disable Neovim's built-in synthetic reply to OSC 10/11 queries from
    -- :terminal children. The synthetic "rgb:ffff/ffff/ffff" reply leaks
    -- into yazi (via yazi.nvim) and gets interpreted as keyboard input.
    -- See runtime/lua/vim/_core/defaults.lua (augroup "nvim.terminal").
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        pcall(vim.api.nvim_clear_autocmds, {
          group = "nvim.terminal",
          event = "TermRequest",
        })
      end,
    })
  '';
}
