return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.6',
        dependencies = {
            'nvim-lua/plenary.nvim',
            -- 'folke/which-key.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
        },
        -- opts_desc = {
        --     defaults = { vimgrep_arguments = { 'rg', '--hidden', '--color=never', '--no-heading', '--with-filename', '--line-number', '--column', '--smart-case' }, },
        -- },
        config = function()
            local builtin = require('telescope.builtin')
            local function opts(desc)
                return { desc = "Telescope: " .. desc, noremap = true, silent = true }
            end
            vim.keymap.set('n', '<leader>f', builtin.find_files, opts("Find Files"))
            vim.keymap.set('n', '<leader>g', builtin.live_grep, opts("Live Grep"))
            vim.keymap.set('n', '<leader>tb', builtin.buffers, opts("Buffers"))
            vim.keymap.set('n', '<leader>th', builtin.help_tags, opts("Help Tags"))
            vim.keymap.set('n', '<leader>tr', builtin.registers, opts("Registers"))
            vim.keymap.set('n', '<leader>tc', builtin.commands, opts("Commands"))
            vim.keymap.set('n', '<leader>td', ':Telescope resume<CR>', opts("Resume Last"))
            -- vim.keymap.set('n', '-', builtin.git_status, opts("Git Status"))

            function vim.getVisualSelection()
                vim.cmd('noau normal! "vy"')
                local text = vim.fn.getreg('v')
                vim.fn.setreg('v', {})

                text = string.gsub(text, "\n", "")
                if #text > 0 then
                    return text
                else
                    return ''
                end
            end

            vim.keymap.set('n', '<leader>*', 'viw<leader>g', opts("Global Fuzzy Find Word"))

            vim.keymap.set('v', '<leader>g', function()
                local text = vim.getVisualSelection()
                builtin.live_grep({ default_text = text })
            end, opts("Live Grep Selection"))

            vim.keymap.set('n', 'gw', function()
                vim.cmd('normal! viw"xy')
                local text = vim.fn.getreg('x')
                builtin.live_grep({ default_text = text })
            end, opts("Live Grep Selection"))

            -- key description
            -- local wk = require("which-key")
            -- wk.register({
            --     f = "Telescope: find",
            -- }, { prefix = "<leader>" })

            require("telescope").setup {
                pickers = {
                    diagnostics = {
                        theme = "dropdown",
                        previewer = true,
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown {
                            -- even more opts
                        }

                        -- pseudo code / specification for writing custom displays, like the one
                        -- for "codeactions"
                        -- specific_opts = {
                        --   [kind] = {
                        --     make_indexed = function(items) -> indexed_items, width,
                        --     make_displayer = function(widths) -> displayer
                        --     make_display = function(displayer) -> function(e)
                        --     make_ordinal = function(e) -> string
                        --   },
                        --   -- for example to disable the custom builtin "codeactions" display
                        --      do the following
                        --   codeactions = false,
                        -- }
                    }
                },
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                        },
                        n = {
                            ["<C-j>"] = require("telescope.actions").move_selection_next,
                            ["<C-k>"] = require("telescope.actions").move_selection_previous,
                        },
                    },
                },
            }
            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end,
    },
}
