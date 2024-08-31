return {
    {
        "ggandor/flit.nvim",
        dependencies = { "ggandor/leap.nvim", "tpope/vim-repeat" },
        config = function()
            require('flit').setup {
                keys = { f = 'f', F = 'F', t = 't', T = 'T' },
                -- A string like "nv", "nvo", "o", etc.
                labeled_modes = "v",
                -- Repeat with the trigger key itself.
                clever_repeat = true,
                multiline = true,
                -- Like `leap`s similar argument (call-specific overrides).
                -- E.g.: opts = { equivalence_classes = {} }
                opts = {}
            }
        end,
    },
    {
        "ggandor/leap.nvim",
        dependencies = { "tpope/vim-repeat" },
        config = function()
            -- require("leap").create_default_mappings()
            vim.keymap.set('n', 's', '<Plug>(leap)')
            vim.keymap.set('n', 'S', '<Plug>(leap-from-window)')
            vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)')
            vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)')
        end,
    },
    {
        "Pocco81/auto-save.nvim",
        config = function()
            require("auto-save").setup {
                -- your config goes here
                -- or just leave it empty :)
            }
        end,
    },
    { "nvim-lua/plenary.nvim" },
    { 'nvim-tree/nvim-web-devicons' },
    -- {
    --     "max397574/better-escape.nvim",
    --     opts = {
    --         timeout = 1000,
    --         default_mappings = false,
    --         mappings = {
    --             i = {
    --                 j = {
    --                     j = "<Esc>",
    --                 },
    --             },
    --             c = {
    --                 j = {
    --                     j = "<Esc>",
    --                 },
    --             },
    --             t = {
    --                 j = {
    --                     j = "<Esc>",
    --                 },
    --             },
    --             v = {
    --                 j = {
    --                 },
    --             },
    --             s = {
    --                 j = {
    --                 },
    --             },
    --         },
    --     },
    -- },unmap_keys
    -- {
    --     "startup-nvim/startup.nvim",
    --     dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    --     opts = {
    --         theme = "dashboard",
    --     },
    -- },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
    },
    -- {
    --     'smolck/command-completion.nvim',
    --     opts = {
    --         border = nil,                 -- What kind of border to use, passed through directly to `nvim_open_win()`,
    --         -- see `:help nvim_open_win()` for available options (e.g. 'single', 'double', etc.)
    --         max_col_num = 5,              -- Maximum number of columns to display in the completion window
    --         min_col_width = 20,           -- Minimum width of completion window columns
    --         use_matchfuzzy = true,        -- Whether or not to use `matchfuzzy()` (see `:help matchfuzzy()`)
    --         -- to order completion results
    --         highlight_selection = true,   -- Whether or not to highlight the currently
    --         -- selected item, not sure why this is an option tbh
    --         highlight_directories = true, -- Whether or not to higlight directories with
    --         -- the Directory highlight group (`:help hl-Directory`)
    --         tab_completion = true,        -- Whether or not tab completion on displayed items is enabled
    --     },
    -- },
    {
        "github/copilot.vim",
    },
    {
        'uga-rosa/translate.nvim',
    },
}
