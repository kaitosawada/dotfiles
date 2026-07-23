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
    -- OSC 52 only over SSH. Locally, leave unset so Neovim uses pbcopy on
    -- macOS (or wl-copy/xclip on Linux). Forcing OSC 52 everywhere breaks
    -- "*y / gy on local terminals that don't handle clipboard OSC well.
    if vim.env.SSH_TTY then
      local function paste()
        return {
          vim.split(vim.fn.getreg(""), "\n"),
          vim.fn.getregtype(""),
        }
      end
      vim.g.clipboard = {
        name = "OSC 52",
        copy = {
          ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
          ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        -- OSC 52 paste is often blocked by terminals; avoid hangs.
        paste = {
          ["+"] = paste,
          ["*"] = paste,
        },
      }
    end

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
