{ pkgs, ... }:
{
  pkgs,
  ...
}:
{
  # https://nix-community.github.io/nixvim/plugins/lsp-format/index.html
  plugins.lsp-format = {
    enable = true;
  };
  # https://github.com/nix-community/nixvim/blob/main/plugins/lsp/lsp-packages.nix
  plugins.lsp = {
    enable = true;
    servers = {
      nixd.enable = true;

      # TypeScript / JavaScript
      biome = {
        enable = true;
      };
      ts_ls = {
        enable = true;
        filetypes = [
          "typescript"
          "typescriptreact"
          "typescript.tsx"
        ];
      };

      # CSS / HTML
      cssls.enable = true; # CSS
      tailwindcss.enable = true; # TailwindCSS
      html.enable = true; # HTML

      # Vue
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

      # etc.
      marksman.enable = true; # Markdown
      dockerls.enable = true; # Docker
      bashls.enable = true; # Bash
      yamlls.enable = true; # YAML
      terraformls.enable = true; # Terraform
      sqls.enable = true; # SQL

      # Python
      ruff.enable = true; # Ruff (Linter)
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
        rustcPackage = pkgs.rustc;
        cargoPackage = pkgs.cargo;
        installRustc = false;
        installCargo = false;
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
