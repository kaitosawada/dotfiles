{
  plugins.toggleterm = {
    enable = true;
    settings = {
      direction = "float";
      float_opts = {
        border = "curved";
        width = 120;
        height = 30;
      };
      close_on_exit = false;
      start_in_insert = true;
      shell.__raw = "vim.o.shell";
    };
  };

  extraConfigLua = ''
    local Terminal = require('toggleterm.terminal').Terminal

    -- Filetype to command mapping for running current buffer
    local run_commands = {
      python = "python3 '%s'",
      javascript = "bun '%s'",
      typescript = "bun '%s'",
      lua = "lua '%s'",
      sh = "bash '%s'",
      bash = "bash '%s'",
      zsh = "zsh '%s'",
    }

    -- Dedicated terminal for running scripts
    local run_terminal = nil

    -- Function to run current buffer in floating terminal
    function _G.run_current_buffer()
      local ft = vim.bo.filetype
      local file = vim.fn.expand('%:p')

      if file == "" then
        vim.notify("No file to run", vim.log.levels.WARN)
        return
      end

      -- Save file before running
      vim.cmd('write')

      local cmd = run_commands[ft]
      if cmd then
        local full_cmd = string.format(cmd, file)

        -- Close existing terminal if open
        if run_terminal then
          run_terminal:shutdown()
        end

        -- Create new terminal with the command
        run_terminal = Terminal:new({
          cmd = full_cmd,
          direction = "float",
          close_on_exit = false,
          on_open = function()
            vim.cmd("startinsert!")
          end,
        })
        run_terminal:toggle()
      else
        vim.notify("No run command defined for filetype: " .. ft, vim.log.levels.WARN)
      end
    end
  '';

  keymaps = [
    {
      mode = "n";
      key = "<leader>r";
      action.__raw = "function() _G.run_current_buffer() end";
      options = {
        desc = "Run current buffer in floating terminal";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>tt";
      action = "<cmd>ToggleTerm<CR>";
      options = {
        desc = "Toggle floating terminal";
        silent = true;
      };
    }
    {
      mode = "t";
      key = "<Esc><Esc>";
      action = "<C-\\><C-n><cmd>ToggleTerm<CR>";
      options = {
        desc = "Close floating terminal";
        silent = true;
      };
    }
  ];
}
