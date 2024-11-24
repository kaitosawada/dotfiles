{
  imports = [
    ./plugins
    ./keymappings.nix
    ./theme.nix
  ];
  enable = true;

  globals.mapleader = " ";

  opts = {
    tabstop = 4;
    shiftwidth = 4;
    expandtab = true;
    number = true;
  };

  userCommands = {
    "Wq" = {
      command = "wq";
    };
  };
}
