{
  # extraPlugins = with pkgs.vimPlugins; [
  #   lazygit-nvim
  # ];

  extraConfigLua = ''
    require("telescope").load_extension("lazygit")
  '';

  plugins.lazygit.enable = true;

  keymaps = [
    {
      mode = "n";
      key = "<leader>lg";
      action = "<cmd>LazyGit<CR>";
      options = {
        desc = "LazyGit (root dir)";
      };
    }
  ];
}
