{
  plugins.lsp = {
    enable = true;
    servers = {
      nixd.enable = true;
      ts_ls.enable = true; # TS/JS
      cssls.enable = true; # CSS
      html.enable = true; # HTML
      astro.enable = true; # AstroJS
      vuels.enable = false; # Vue
      basedpyright.enable = true; # Python
      ruff.enable = true; # Python
      marksman.enable = true; # Markdown
      dockerls.enable = true; # Docker
      bashls.enable = true; # Bash
      clangd.enable = true; # C/C++
      csharp_ls.enable = true; # C#
      yamlls.enable = true; # YAML
      gopls = {
        # Golang
        enable = true;
        autostart = true;
      };

      lua_ls = {
        # Lua
        enable = true;
        settings.telemetry.enable = false;
      };

      # Rust
      rust_analyzer = {
        enable = true;
        installRustc = true;
        installCargo = true;
      };
    };
    keymaps = {
      silent = true;
      diagnostic = {
        "<leader>k" = "goto_prev";
        "<leader>j" = "goto_next";
      };
      lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "<leader>cc" = "hover";
      };
    };
  };
}
