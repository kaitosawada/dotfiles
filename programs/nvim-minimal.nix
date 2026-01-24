{ pkgs, inputs, ... }:
let
  nvimMinimal = inputs.nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [
        ./nixvim/config.nix
        ./nixvim/theme.nix
        ./nixvim/keymappings.nix
        ./nixvim/plugins/skkeleton.nix
        ./nixvim/plugins/blink-cmp.nix
      ];

      extraConfigLua = ''
        vim.api.nvim_create_autocmd({"VimEnter", "BufReadPost"}, {
          callback = function()
            local filename = vim.fn.expand("%:t")
            if filename:match("^claude%-prompt%-.*%.md$") then
              vim.defer_fn(function()
                vim.cmd("normal! G$")
                vim.cmd("startinsert!")
              end, 10)
            elseif filename:match("%.dump$") then
              vim.defer_fn(function()
                vim.cmd("normal! G0")
              end, 10)
            end
          end
        })
      '';
    };
  };
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "nvim-minimal" ''
      exec ${nvimMinimal}/bin/nvim "$@"
    '')
  ];
}
