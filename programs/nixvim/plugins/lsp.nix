{
  # https://github.com/nix-community/nixvim/blob/main/plugins/lsp/lsp-packages.nix
  plugins.lsp = {
    enable = true;
    servers = {
      nixd.enable = true;
      ts_ls.enable = true; # TS/JS
      cssls.enable = true; # CSS
      html.enable = true; # HTML
      astro.enable = true; # AstroJS
      vuels.enable = false; # Vue
      marksman.enable = true; # Markdown
      dockerls.enable = true; # Docker
      bashls.enable = true; # Bash
      yamlls.enable = true; # YAML
      terraformls.enable = true; # Terraform
      ruff.enable = true; # Python
      basedpyright = {
        enable = true;
        settings = {
          basedpyright = {
            disableOrganizeImports = true;
            analysis = {
              typeCheckingMode = "standard";
              autoImportCompletions = true;
            };
          };
        };
      };
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
        # "<leader>k" = "goto_prev";
        # "<leader>j" = "goto_next";
        "<leader>ce" = "open_float";
      };
      lspBuf = {
        "gd" = "definition";
        "gD" = "references";
        "gt" = "type_definition";
        "gi" = "implementation";
        "<leader>cc" = "hover";
        "<leader>ll" = "format";
      };
    };
  };
}
