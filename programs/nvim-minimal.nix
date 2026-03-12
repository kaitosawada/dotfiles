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
        ./nixvim/plugins/flash.nix
        ./nixvim/plugins/copilot-lua.nix
        ./nixvim/plugins/copilot-chat.nix
      ];

      keymaps = [
        {
          mode = "n";
          key = "<CR>";
          action = "<CMD>wq<CR>";
          options = {
            desc = "Save and quit";
            noremap = true;
            silent = true;
          };
        }
        {
          mode = "n";
          key = "<leader>g";
          action.__raw = ''
            function()
              local chat = require("CopilotChat")
              local commit_buf = vim.api.nvim_get_current_buf()
              local diff = vim.fn.system("git diff --staged")
              if vim.v.shell_error ~= 0 or diff == "" then
                vim.notify("staged diffがありません", vim.log.levels.WARN)
                return
              end
              chat.ask(
                "以下のdiffに対してcommitizen規約に従ったコミットメッセージを日本語で書いてください。"
                .. "タイトルは50文字以内、本文は72文字で折り返してください。"
                .. "コードブロックのマーカーなしで、コミットメッセージのみを出力してください。\n\n"
                .. diff,
                {
                  callback = function(response)
                    local text = response.content or tostring(response)
                    local lines = vim.split(text, "\n")
                    vim.api.nvim_buf_set_lines(commit_buf, 0, 0, false, lines)
                    chat.close()
                  end,
                }
              )
            end
          '';
          options = {
            desc = "Generate commit message";
            noremap = true;
            silent = true;
          };
        }
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
