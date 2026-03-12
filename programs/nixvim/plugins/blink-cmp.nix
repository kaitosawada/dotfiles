{
  # https://nix-community.github.io/nixvim/plugins/blink-cmp/index.html

  # Custom source: @ triggers file path completion (for Claude Code prompt editor)
  # git ls-files で全ファイルを取得し、blink-cmp のファジーマッチに委ねる
  extraFiles."lua/blink-cmp-at-file/init.lua".text = ''
    local source = {}

    function source.new(opts)
      local self = setmetatable({}, { __index = source })
      self.opts = opts or {}
      return self
    end

    function source:get_trigger_characters()
      return { "@" }
    end

    function source:get_completions(ctx, callback)
      local cursor_col = ctx.cursor[2]
      local line = ctx.line
      local before_cursor = line:sub(1, cursor_col)

      local at_start = before_cursor:match("()@[%w%-%._/]*$")
      if not at_start then
        callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
        return
      end

      -- Only trigger when @ is at start of line or preceded by whitespace
      if at_start > 1 and not before_cursor:sub(at_start - 1, at_start - 1):match("%s") then
        callback({ items = {}, is_incomplete_forward = false, is_incomplete_backward = false })
        return
      end

      local cwd = vim.fn.getcwd()
      local files = vim.fn.systemlist("git -C " .. vim.fn.shellescape(cwd) .. " ls-files 2>/dev/null")
      if vim.v.shell_error ~= 0 then
        files = vim.fn.globpath(cwd, "**/*", false, true)
        for i, f in ipairs(files) do
          files[i] = f:sub(#cwd + 2)
        end
      end

      local items = {}
      for _, file in ipairs(files) do
        if file ~= "" then
          table.insert(items, {
            label = file,
            kind = 17,
            textEdit = {
              newText = "@" .. file .. " ",
              range = {
                start = {
                  line = ctx.cursor[1] - 1,
                  character = at_start - 1,
                },
                ["end"] = {
                  line = ctx.cursor[1] - 1,
                  character = cursor_col,
                },
              },
            },
          })
        end
      end

      callback({
        items = items,
        is_incomplete_forward = false,
        is_incomplete_backward = false,
      })
    end

    return source
  '';

  plugins.blink-cmp = {
    enable = true;
    settings = {
      keymap = {
        # "<C-Enter>" = [
        #   "select_and_accept"
        #   {
        #     __raw = ''
        #       function(cmp) cmp.show({ providers = { "codeium" } }) end
        #     '';
        #   }
        #   "fallback"
        # ];
        # "<Tab>" = [
        #   "select_and_accept"
        #   "fallback"
        # ];
      };
      sources = {
        default = [
          "lsp"
          "path"
          # "snippets"
          "buffer"
          "at-file"
        ];
        providers = {
          path = {
            opts = {
              get_cwd = {
                __raw = ''
                  function(_)
                    return vim.fn.getcwd()
                  end,
                '';
              };
            };
          };
          "at-file" = {
            name = "at-file";
            module = "blink-cmp-at-file";
          };
        };
      };
    };
  };
}
