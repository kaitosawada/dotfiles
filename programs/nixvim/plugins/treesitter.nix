{
  plugins = {
    treesitter = {
      enable = true;
      # lazyLoad = {
      #   settings = {
      #     ft = [
      #       "lua"
      #       "nix"
      #       "rust"
      #       "typescript"
      #       "tsx"
      #       "javascript"
      #       "react-typescript"
      #       "json"
      #       "css"
      #       "html"
      #       "bash"
      #       "c"
      #       "java"
      #       "markdown"
      #       "python"
      #       "query"
      #       "regex"
      #       "vim"
      #       "yaml"
      #     ];
      #   };
      # };
      settings = {
        highlight = {
          enable = true;
        };
        indent = {
          enable = true;
        };
        autopairs = {
          enable = true;
        };
        folding = {
          enable = true;
        };
        ensure_installed = [
          "bash"
          "c"
          "html"
          "css"
          "javascript"
          "jsdoc"
          "json"
          "lua"
          "luadoc"
          "luap"
          "nix"
          "rust"
          "java"
          "markdown"
          "markdown_inline"
          "python"
          "query"
          "regex"
          "swift"
          "tsx"
          "typescript"
          "vim"
          "vimdoc"
          "toml"
          "yaml"
        ];
        auto_install = true;
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
      nixvimInjections = true;
    };
  };
}
