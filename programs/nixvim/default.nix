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
    conceallevel = 1;
  };

  userCommands = {
    "Wq" = {
      command = "wq";
    };
  };
}
