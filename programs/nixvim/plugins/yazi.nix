{
  # https://yazi-rs.github.io/docs/installation/
  plugins.yazi = {
    enable = true;
  };

  keymaps = [
    {
      mode = [
        "n"
        "v"
      ];
      key = "-";
      action = "<CMD>Yazi<CR>";
      options = {
        desc = "Yazi: Open";
        noremap = true;
        silent = true;
      };
    }
  ];
}
