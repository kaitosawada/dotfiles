{
  nix.enable = true;
  pluging.lsp = {
    enable = true;
    servers = {
      # Average webdev LSPs
      # ts-ls.enable = true; # TS/JS
      ts_ls.enable = true; # TS/JS
      cssls.enable = true; # CSS
      tailwindcss.enable = true; # TailwindCSS
      html.enable = true; # HTML
      astro.enable = true; # AstroJS
      vuels.enable = false; # Vue
      basedpyright.enable = true; # Python
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
  };
}
