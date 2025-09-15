---@type overseer.TemplateDefinition
return {
  name = "First Template",
  builder = function()
    local file = vim.fn.expand("%")
    ---@type overseer.TaskDefinition
    return {
      cmd = { "echo" },
      args = { "hello", file },
    }
  end,
}
