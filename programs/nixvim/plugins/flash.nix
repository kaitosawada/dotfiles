{
  plugins.flash = {
    enable = true;
  };
  keymaps = [
    {
      mode = "n";
      key = "s";
      action.__raw = "function() require(\"flash\").jump() end";
      options = {
        desc = "flash.nvim: Jump";
        noremap = true;
      };
    }
    {
      mode = "n";
      key = "S";
      action.__raw = "function() require(\"flash\").treesitter() end";
      options = {
        desc = "flash.nvim: Treesitter";
        noremap = true;
      };
    }
  ];
}
