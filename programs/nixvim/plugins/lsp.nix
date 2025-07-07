{
  # https://github.com/nix-community/nixvim/blob/main/plugins/lsp/lsp-packages.nix
  plugins.lsp = {
    enable = true;
    servers = {
      nixd.enable = true;
      # TS/JS
      ts_ls = {
        enable = true;
        filetypes = [
          "typescript"
          "typescriptreact"
          "typescript.tsx"
        ];
      };
      # biome
      biome.enable = true;
      cssls.enable = true; # CSS
      tailwindcss.enable = true; # TailwindCSS
      html.enable = true; # HTML
      astro.enable = false; # AstroJS
      emmet_ls = {
        enable = true;
        filetypes = [
          "html"
          "css"
          "scss"
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "svelte"
          "vue"
        ];
      };
      svelte.enable = false; # Svelte
      volar = {
        enable = true; # Vue
        # volar formatter indent is broken, so we disable it in favor of prettier
        onAttach.function = ''
          on_attach = function(client)
            client.server_capabilities.document_formatting = false
            client.server_capabilities.document_range_formatting = false
          end
        '';
        onAttach.override = true;
      };
      vuels.enable = false; # Vue
      marksman.enable = true; # Markdown
      dockerls.enable = true; # Docker
      bashls.enable = true; # Bash
      yamlls.enable = true; # YAML
      terraformls.enable = true; # Terraform
      ruff.enable = true; # Python
      sqls.enable = true; # SQL
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

      # Golang
      gopls = {
        enable = true;
        autostart = true;
      };

      # Lua
      lua_ls = {
        enable = true;
        settings.telemetry.enable = false;
        settings.diagnostics.globals = [ "vim" ];
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
        "<leader>cc" = "hover";
        "<leader>ll" = "format";
        "<leader>ca" = "code_action";
      };
    };
  };
}
