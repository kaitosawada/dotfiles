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

  userCommands = {
    "Wq" = {
      command = "wq";
    };
  };

  # extraConfigLuaPre = builtins.readFile lua/bitwarden.lua;
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
  '';
}
