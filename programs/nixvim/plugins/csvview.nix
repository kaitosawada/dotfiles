{
  plugins.csvview = {
    enable = true;
  };
  extraConfigLua = ''
    --[[ csvview ]]--
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "csv",
      callback = function()
        vim.opt_local.wrap = false
        require('csvview').enable()
      end,
    })
    --[[ csvview ]]--
  '';
}
