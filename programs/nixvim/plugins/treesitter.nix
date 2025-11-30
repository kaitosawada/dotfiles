{
  plugins = {
    treesitter = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = [ "BufReadPost" "BufNewFile" ];
      };
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
          "swift"
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
