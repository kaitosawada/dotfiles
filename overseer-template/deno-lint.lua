---@type overseer.TemplateDefinition
return {
  name = "Deno: Lint",
  builder = function()
    ---@type overseer.TaskDefinition
    return {
      strategy = { "jobstart", use_terminal = false },
      cmd = { "deno" },
      args = { "lint", "--quiet", "--compact" },
      components = {
        {
          "on_output_quickfix",
          open_on_exit = "failure",
          errorformat = "file://%f: line %l\\, col %c - %m",
        },
        "default",
      },
    }
  end,
  condition = {
    callback = function()
      return vim.fs.find(
        { "deno.json", "deno.jsonc" },
        { upward = true, stop = vim.loop.os_homedir() }
      )[1]
    end,
  },
}
