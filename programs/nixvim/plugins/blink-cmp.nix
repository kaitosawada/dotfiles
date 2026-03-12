{
  # https://nix-community.github.io/nixvim/plugins/blink-cmp/index.html

  # Custom source: @ triggers file path completion (for Claude Code prompt editor)
  extraFiles."lua/blink-cmp-at-file/init.lua".text = ''
    local source = {}

    function source.new(opts)
      local self = setmetatable({}, { __index = source })
      self.opts = opts or {}
      return self
    end

    function source:get_trigger_characters()
      return { "@", "/" }
    end

    function source:get_completions(ctx, callback)
      local cursor_col = ctx.cursor[2]
      local line = ctx.line
      local before_cursor = line:sub(1, cursor_col)

      local at_start, at_prefix = before_cursor:match("()@([%w%-%._/]*)$")
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
      local dir_part = at_prefix:match("(.*/)") or ""
      local scan_dir = cwd .. "/" .. dir_part

      local items = {}
      local ok, entries = pcall(vim.fn.readdir, scan_dir)
      if ok then
        for _, entry in ipairs(entries) do
          if not entry:match("^%.") then
            local full_path = scan_dir .. entry
            local is_dir = vim.fn.isdirectory(full_path) == 1
            local relative = dir_part .. entry

            table.insert(items, {
              label = relative .. (is_dir and "/" or ""),
              kind = is_dir and 19 or 17,
              textEdit = {
                newText = "@" .. relative .. (is_dir and "/" or " "),
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
      end

      callback({
        items = items,
        is_incomplete_forward = true,
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
