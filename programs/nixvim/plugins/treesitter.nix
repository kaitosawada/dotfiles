{
  pkgs,
  lib,
  ...
}:
let
  commonGrammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    bash
    c
    html
    css
    javascript
    jsdoc
    json
    lua
    luadoc
    luap
    nix
    rust
    java
    markdown
    markdown_inline
    python
    query
    regex
    tsx
    typescript
    vim
    vimdoc
    toml
    wgsl
    yaml
  ];
  darwinGrammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
    swift
  ];
in
{
  plugins = {
    treesitter = {
      enable = true;
      lazyLoad = {
        enable = true;
        settings.event = [
          "BufReadPost"
          "BufNewFile"
        ];
      };
      grammarPackages = commonGrammars ++ lib.optionals pkgs.stdenv.isDarwin darwinGrammars;
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
        auto_install = false;
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
