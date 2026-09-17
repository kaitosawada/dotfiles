{
  extraConfigLua = ''
    require("telescope").load_extension("lazygit")

    if vim.env.NVIM and vim.fn.executable("nvr") == 1 then
      local nvr = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
      vim.env.EDITOR = nvr
      vim.env.VISUAL = nvr
      vim.env.GIT_EDITOR = nvr
    end
  '';

  plugins.lazygit = {
    enable = true;
    settings.use_neovim_remote = 1;
  };

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
