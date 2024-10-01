return {
    { 'Tyler-Barham/floating-help.nvim' },
    -- {
    --     'sidebar-nvim/sidebar.nvim',
    --     config = function()
    --         require('sidebar-nvim').setup({
    --             open = false,
    --             sections = {
    --                 "git",
    --                 "diagnostics",
    --                 "todos",
    --             },
    --         })
    --         vim.keymap.set("n", "<leader>o", "<CMD>SidebarNvimToggle<CR>")
    --     end,
    -- },
    { 'folke/todo-comments.nvim' },
    {
        "j-hui/fidget.nvim",
        opts = {
            -- options
        },
    },
    {
        'gen740/SmoothCursor.nvim',
        opts = {
            priority = 10,
            fancy = {
                enable = true,
                body = {
                    -- { cursor = "◆", texthl = "SmoothCursorRed" },
                    -- { cursor = "◆", texthl = "SmoothCursorOrange" },
                    -- { cursor = "◇", texthl = "SmoothCursorYellow" },
                    -- { cursor = "◇", texthl = "SmoothCursorGreen" },
                    -- { cursor = "⋄", texthl = "SmoothCursorAqua" },
                    -- { cursor = "⋄", texthl = "SmoothCursorBlue" },
                    -- { cursor = "∙", texthl = "SmoothCursorPurple" }
                    { cursor = "◆", texthl = "SmoothCursorRed" },
                    { cursor = "✳", texthl = "SmoothCursorOrange" },
                    { cursor = "✴", texthl = "SmoothCursorYellow" },
                    { cursor = "✶", texthl = "SmoothCursorGreen" },
                    { cursor = ".", texthl = "SmoothCursorAqua" },
                    { cursor = ".", texthl = "SmoothCursorBlue" },
                    { cursor = "✷", texthl = "SmoothCursorPurple" },
                },
            },
            disabled_filetypes = {
                "TelescopePrompt",
                "TelescopeResults",
                "gitblame",
                "css",
                "noice",
                "lazy",
            },
        },
    },
    { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
            require('lualine').setup({
                options = {
                    theme = 'catppuccin',
                    section_separators = { '', '' },
                    component_separators = { '', '' },
                    path = 1,
                    icons_enabled = true,
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch' },
                    lualine_c = { 'filename' },
                    lualine_x = { 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location'  },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { 'filename' },
                    lualine_x = { 'location' },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                extensions = { 'fugitive', 'nvim-tree' },
            })
            -- vim.o.laststatus = 2
            -- vim.o.statusline = vim.o.statusline .. ' CustomString'
        end
    },
}
