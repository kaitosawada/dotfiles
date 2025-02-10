{
  plugins.notify = {
    enable = true;
    settings = {
      on_open.__raw = ''
        function(win)
          vim.api.nvim_win_set_config(win, { focusable = false })
        end
      '';
    };
  };
}
