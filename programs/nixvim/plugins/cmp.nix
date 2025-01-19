{
  plugins.cmp = {
    enable = true;
    autoEnableSources = true;
    settings = {
      mapping = {
        # "<C-d>" = "cmp.mapping.scroll_docs(-4)";
        # "<C-f>" = "cmp.mapping.scroll_docs(4)";
        # "<C-Space>" = "cmp.mapping.complete()";
        "<C-e>" = "cmp.mapping.close()";
        "<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
      sources = [
        { name = "nvim_lsp"; }
        { name = "path"; }
        { name = "buffer"; }
        { name = "skkeleton"; }
      ];
    };
  };
}
