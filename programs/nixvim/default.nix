{
  imports = [
    ./plugins
    ./keymappings.nix
    ./theme.nix
  ];
  enable = true;

  globals.mapleader = " ";

  opts = {
    tabstop = 2;
    shiftwidth = 2;
    expandtab = true;
    number = true;
    laststatus = 3;
  };

  autoCmd = [
    {
      command = "setlocal conceallevel=1";
      event = "FileType";
      pattern = "markdown";
    }
  ];

  # clipboard = {
  #   register = "unnamed,unnamedplus";
  #   providers.xclip = {
  #     enable = true;
  #   };
  # };

  userCommands = {
    "Wq" = {
      command = "wq";
    };
  };

  extraConfigLuaPre = builtins.readFile lua/bitwarden.lua;
  extraConfigLua = ''
    vim.g.clipboard = {
      name = 'OSC 52',
      copy = {
        ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
        ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
      },
      paste = {
        ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
        ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
      },
    }

    vim.api.nvim_create_user_command('OpenInVSCode', function()
      local project_root = vim.fn.system('git rev-parse --show-toplevel'):gsub('\n', "")
      local current_file = vim.fn.expand('%:p')
      local line_num = vim.fn.line('.')
      local col_num = vim.fn.col('.')
      
      if project_root ~= "" then
        vim.fn.system('code ' .. project_root .. ' -g ' .. current_file .. ':' .. line_num .. ':' .. col_num)
      else
        vim.fn.system('code -g ' .. current_file .. ':' .. line_num .. ':' .. col_num)
      end
    end, {})
  '' + builtins.readFile lua/codecompanion.lua;
}
