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

  userCommands = {
    "Wq" = {
      command = "wq";
    };
  };

  extraConfigLuaPre = builtins.readFile ./pre.lua;
}
