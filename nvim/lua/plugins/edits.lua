return {
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    --     opts = {},
    --     keys = {
    --         { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    --         { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    --         { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    --         { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    --         { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    --     },
    -- },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {
            -- add any options here
        },
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        },
    },
    {
        'gbprod/yanky.nvim',
        opts = {
            -- add any options here
        },
        keys = {
            { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({}) end, desc = "Open Yank History" },
            { "gy",        "\"+<Plug>(YankyYank)",                                                       mode = { "n", "x" },                                desc = "Yank Clipboard" },
            { "y",         "<Plug>(YankyYank)",                                                          mode = { "n", "x" },                                desc = "Yank text" },
            { "p",         "<Plug>(YankyPutAfter)",                                                      mode = { "n", "x" },                                desc = "Put yanked text after cursor" },
            { "P",         "<Plug>(YankyPutBefore)",                                                     mode = { "n", "x" },                                desc = "Put yanked text before cursor" },
            -- { "gp",        "<Plug>(YankyGPutAfter)",                                                     mode = { "n", "x" },                                desc = "Put yanked text after selection" },
            -- { "gP",        "<Plug>(YankyGPutBefore)",                                                    mode = { "n", "x" },                                desc = "Put yanked text before selection" },
            { "<c-p>",     "<Plug>(YankyPreviousEntry)",                                                 desc = "Select previous entry through yank history" },
            { "<c-n>",     "<Plug>(YankyNextEntry)",                                                     desc = "Select next entry through yank history" },
            { "]p",        "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = "Put indented after cursor (linewise)" },
            { "[p",        "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = "Put indented before cursor (linewise)" },
            { "]P",        "<Plug>(YankyPutIndentAfterLinewise)",                                        desc = "Put indented after cursor (linewise)" },
            { "[P",        "<Plug>(YankyPutIndentBeforeLinewise)",                                       desc = "Put indented before cursor (linewise)" },
            { ">p",        "<Plug>(YankyPutIndentAfterShiftRight)",                                      desc = "Put and indent right" },
            { "<p",        "<Plug>(YankyPutIndentAfterShiftLeft)",                                       desc = "Put and indent left" },
            { ">P",        "<Plug>(YankyPutIndentBeforeShiftRight)",                                     desc = "Put before and indent right" },
            { "<P",        "<Plug>(YankyPutIndentBeforeShiftLeft)",                                      desc = "Put before and indent left" },
            { "=p",        "<Plug>(YankyPutAfterFilter)",                                                desc = "Put after applying a filter" },
            { "=P",        "<Plug>(YankyPutBeforeFilter)",                                               desc = "Put before applying a filter" },
        },
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
    },
}
