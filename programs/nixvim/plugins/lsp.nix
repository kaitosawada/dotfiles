{
  pkgs,
  ...
}:
{
  # https://github.com/nix-community/nixvim/blob/main/plugins/lsp/lsp-packages.nix
  plugins.lsp = {
    enable = true;
    lazyLoad = {
      enable = true;
      settings.event = [
        "BufReadPost"
        "BufNewFile"
      ];
    };
    servers = {
      nixd.enable = true;

      # TypeScript / JavaScript
      biome = {
        enable = true;
      };

      ts_ls = {
        enable = true;
        onAttach.function = ''
          local root_dir = client.config.root_dir
          if root_dir then
            local deno_json = root_dir .. "/deno.json"
            local deno_jsonc = root_dir .. "/deno.jsonc"
            if vim.fn.filereadable(deno_json) == 1 or vim.fn.filereadable(deno_jsonc) == 1 then
              client.stop()
            end
          end
        '';
        onAttach.override = true;
      };

      denols = {
        enable = true;
        filetypes = [
          "typescript"
        ];
        onAttach.function = ''
          local root_dir = client.config.root_dir
          if root_dir then
            local deno_json = root_dir .. "/deno.json"
            local deno_jsonc = root_dir .. "/deno.jsonc"
            if vim.fn.filereadable(deno_json) ~= 1 and vim.fn.filereadable(deno_jsonc) ~= 1 then
              client.stop()
            end
          end
        '';
        onAttach.override = true;
      };

      # Vue
      vue_ls = {
        enable = true; # Vue
      };

      # CSS / HTML
      cssls.enable = true; # CSS
      tailwindcss.enable = true; # TailwindCSS
      html.enable = true; # HTML

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

      # swift
      sourcekit = {
        enable = true;
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
