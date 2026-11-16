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
      action = "<CMD>Yazi cwd<CR>";
      options = {
        desc = "Yazi: Open at cwd";
        noremap = true;
        silent = true;
      };
    }
  ];
}
