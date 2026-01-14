{
  # https://nix-community.github.io/nixvim/plugins/blink-cmp/index.html
  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        # "<C-Enter>" = [
        #   "select_and_accept"
        #   {
        #     __raw = ''
        #       function(cmp) cmp.show({ providers = { "codeium" } }) end
        #     '';
        #   }
        #   "fallback"
        # ];
        # "<Tab>" = [
        #   "select_and_accept"
        #   "fallback"
        # ];
      };
      sources = {
        default = [
          "lsp"
          "path"
          # "snippets"
          "buffer"
        ];
        providers = {
          path = {
            opts = {
              get_cwd = {
                __raw = ''
                  function(_)
                    return vim.fn.getcwd()
                  end,
                '';
              };
            };
          };
        };
      };
    };
  };
}
