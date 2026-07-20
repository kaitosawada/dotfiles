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
        ./nixvim/plugins/flash.nix

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
              local commit_buf = vim.api.nvim_get_current_buf()
              local filepath = vim.api.nvim_buf_get_name(commit_buf)
              local repo = filepath:match("%.git/COMMIT_EDITMSG$")
                  and vim.fn.fnamemodify(filepath, ":p:h:h")
                or vim.fn.getcwd()
              local diff = vim.fn.system({ "git", "-C", repo, "diff", "--staged" })
              if vim.v.shell_error ~= 0 or diff == "" then
                vim.notify("staged diffがありません", vim.log.levels.WARN)
                return
              end
              local prompt = "Write a commit message in Japanese for the following diff. "
                .. "Follow the Commitizen convention. "
                .. "Title must be under 50 characters. Wrap body at 72 characters. "
                .. "Output ONLY the raw commit message text. "
                .. "Do NOT wrap it in a code block or add any markdown formatting.\n\n"
                .. diff
              vim.notify("Generating commit message...", vim.log.levels.INFO)
              local stdout_acc = {}
              local stderr_acc = {}
              vim.fn.jobstart({
                "opencode",
                "run",
                "--format",
                "json",
                "--agent",
                "plan",
                "-m",
                "fireworks-ai/accounts/fireworks/models/deepseek-v4-flash",
                prompt,
              }, {
                cwd = repo,
                stdin = "null",
                stdout_buffered = true,
                stderr_buffered = true,
                on_stdout = function(_, data, _)
                  if data then
                    vim.list_extend(stdout_acc, data)
                  end
                end,
                on_stderr = function(_, data, _)
                  if data then
                    vim.list_extend(stderr_acc, data)
                  end
                end,
                on_exit = function(_, exit_code)
                  vim.schedule(function()
                    if exit_code ~= 0 then
                      local err = table.concat(stderr_acc, "\n"):gsub("%s+$", "")
                      if err == "" then
                        err = "exit code " .. exit_code
                      end
                      vim.notify("opencode failed: " .. err, vim.log.levels.ERROR)
                      return
                    end
                    local text
                    local err_msg
                    for _, line in ipairs(stdout_acc) do
                      if line ~= "" then
                        local ok, obj = pcall(vim.json.decode, line)
                        if ok and obj then
                          if obj.type == "text" and obj.part and obj.part.text then
                            if not text then
                              text = obj.part.text
                            else
                              text = text .. obj.part.text
                            end
                          elseif obj.type == "error" then
                            err_msg = (obj.error and obj.error.data and obj.error.data.message)
                              or vim.inspect(obj.error)
                          end
                        end
                      end
                    end
                    if text then
                      text = text:gsub("^```[%w_]*%s*\n", ""):gsub("\n```%s*$", "")
                      text = text:gsub("^%s*\n", ""):gsub("\n%s*$", "")
                      local lines = vim.split(text, "\n", { plain = true })
                      vim.api.nvim_buf_set_lines(commit_buf, 0, 0, false, lines)
                      vim.notify("Commit message inserted", vim.log.levels.INFO)
                    else
                      vim.notify(
                        err_msg and ("opencode error: " .. err_msg) or "opencode: no text response",
                        vim.log.levels.WARN
                      )
                    end
                  end)
                end,
              })
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
            local filepath = vim.fn.expand("%:p")
            if not filepath:match("%.git/COMMIT_EDITMSG$") then
              vim.defer_fn(function()
                vim.cmd("normal! G$")
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
