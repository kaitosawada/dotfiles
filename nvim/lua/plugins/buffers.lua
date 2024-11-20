return {
    {
        'akinsho/bufferline.nvim',
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            vim.opt.termguicolors = true
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, _diagnostics_dict, _context)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                },
                highlights = {
                    fill = {
                        fg = 'gray',
                        -- bg = '#00FF00',
                    },
                    background = {
                        fg = 'gray',
                        -- bg = '#00FF00',
                    },
                    tab = {
                        fg = 'gray',
                        -- bg = '#00FF00',
                    },
                    -- tab_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- tab_separator = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- tab_separator_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     underline = true,
                    -- },
                    -- tab_close = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- close_button = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- close_button_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- close_button_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- buffer_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- buffer_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- numbers = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- numbers_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- numbers_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- diagnostic = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- diagnostic_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- diagnostic_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    hint = {
                        fg = 'gray',
                        -- fg = '#00FF00',
                        -- sp = '#00FF00',
                        -- bg = '#00FF00',
                    },
                    -- hint_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- hint_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- hint_diagnostic = {
                    --     fg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- hint_diagnostic_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- hint_diagnostic_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    info = {
                        fg = 'gray',
                        -- fg = '#00FF00',
                        -- sp = '#00FF00',
                        -- bg = '#00FF00',
                    },
                    -- info_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- info_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- info_diagnostic = {
                    --     fg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- info_diagnostic_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- info_diagnostic_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    warning = {
                        fg = 'gray',
                        -- fg = '#00FF00',
                        -- sp = '#00FF00',
                        -- bg = '#00FF00',
                    },
                    -- warning_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- warning_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- warning_diagnostic = {
                    --     fg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- warning_diagnostic_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- warning_diagnostic_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- error = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    -- },
                    -- error_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- error_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- error_diagnostic = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    -- },
                    -- error_diagnostic_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- error_diagnostic_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     sp = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    modified = {
                        fg = 'gray',
                        -- fg = '#00FF00',
                        -- bg = '#00FF00',
                    },
                    -- modified_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- modified_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- duplicate_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     italic = true,
                    -- },
                    -- duplicate_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     italic = true,
                    -- },
                    -- duplicate = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     italic = true,
                    -- },
                    -- separator_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- separator_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- separator = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- indicator_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- indicator_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- pick_selected = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- pick_visible = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- pick = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    --     bold = true,
                    --     italic = true,
                    -- },
                    -- offset_separator = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                    -- trunc_marker = {
                    --     fg = '#00FF00',
                    --     bg = '#00FF00',
                    -- },
                },
            })
            -- use keymap in file-header-view(bufferline-plugin)
            -- bufferline close setting
            vim.keymap.set('n', '<leader>wl', '<CMD>BufferLineCloseRight<CR>')
            vim.keymap.set('n', '<leader>wh', '<CMD>BufferLineCloseLeft<CR>')
            vim.keymap.set('n', '<leader>wa', '<CMD>BufferLineCloseOthers<CR>')
            vim.keymap.set('n', '<leader>we', '<CMD>BufferLinePickClose<CR>')

            -- (reference)https://github.com/kazhala/dotfiles/blob/master/.config/nvim/lua/kaz/plugins/bufferline.lua
            vim.keymap.set('n', 'gb', '<CMD>BufferLinePick<CR>')
            vim.keymap.set('n', '<C-S-l>', '<CMD>BufferLineCycleNext<CR>')
            vim.keymap.set('n', '<C-S-h>', '<CMD>BufferLineCyclePrev<CR>')
            vim.keymap.set('n', '<S-l>', '<CMD>BufferLineCycleNext<CR>')
            vim.keymap.set('n', '<S-h>', '<CMD>BufferLineCyclePrev<CR>')
            vim.keymap.set('n', ']b', '<CMD>BufferLineMoveNext<CR>')
            vim.keymap.set('n', '[b', '<CMD>BufferLineMovePrev<CR>')
            vim.keymap.set('n', 'gs', '<CMD>BufferLineSortByDirectory<CR>')
            -- local wk = require("which-key")
            -- wk.register({
            --     w = "Bufferline: close tab",
            -- }, { prefix = "<leader>" })
        end
    },
}
