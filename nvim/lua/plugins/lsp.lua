return {
    --  {
    --      "nvimtools/none-ls.nvim",
    --      dependencies = { "nvim-lua/plenary.nvim" },
    --      opts = function(_, opts)
    --          local nls = require('null-ls').builtins
    --          opts.sources = vim.list_extend(opts.sources or {}, {
    -- 	nls.formatting.biome,
    --
    -- 	-- or if you like to live dangerously like me:
    -- 	nls.formatting.biome.with({
    -- 		args = {
    -- 			'check',
    -- 			'--apply-unsafe',
    -- 			'--formatter-enabled=true',
    -- 			'--organize-imports-enabled=true',
    -- 			'--skip-errors',
    -- 			'$FILENAME',
    -- 		},
    -- 	}),
    -- })
    --      end,
    --  },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'nvim-telescope/telescope.nvim',
            'folke/which-key.nvim',
        },
        config = function()
            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            -- LSPがアタッチされた時に以下のキーをマップする
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Buffer local mappings.
                    -- See `:help vim.lsp.*` for documentation on any of the below functions
                    local function opts(desc)
                        return { desc = "LSP: " .. desc, buffer = ev.buf }
                    end
                    vim.keymap.set('n', 'gc', vim.lsp.buf.declaration, opts('jump to declaration'))
                    vim.keymap.set('n', 'gd', function()
                        require('telescope.builtin').lsp_definitions(
                            {
                                initial_mode = "normal",
                                on_complete = {
                                    function()
                                        vim.cmd('normal! zz')
                                    end,
                                },
                            }
                        )
                    end, opts('jump to definition'))
                    vim.keymap.set('n', '<leader>cc', vim.lsp.buf.hover, opts('hover'))
                    vim.keymap.set('n', '<leader>ch', vim.lsp.buf.signature_help, opts('signature help'))
                    vim.keymap.set('n', '<leader>ce', vim.diagnostic.open_float, opts('open diagnostics'))
                    -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts_desc('go to previous diagnostic'))
                    -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts_desc('go to next diagnostic'))
                    vim.keymap.set('n', '<leader>q', '<cmd>Telescope diagnostics<CR>', opts('set loclist'))
                    -- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts_desc('set loclist'))
                    -- vim.keymap.set('n', '<leader>j', vim.diagnostic.show_line_diagnostics)
                    -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts('hover'))
                    -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts('signature help'))
                    -- vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts('add workspace folder'))
                    -- vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts('remove workspace folder'))
                    -- vim.keymap.set('n', '<leader>wl', function()
                    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    -- end, opts('list workspace folders'))
                    vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, opts('type definition'))
                    vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, opts('rename'))
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts('code action'))
                    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts(''))
                    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts(''))
                    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts('find references'))
                    vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts('find implementations'))
                    -- when buffer is python file
                    if vim.bo.filetype == 'python' then
                        vim.keymap.set('n', '<leader>ll', function()
                            vim.lsp.buf.format { async = true }
                            vim.cmd('!ruff check --fix %')
                        end, opts('format'))
                    else
                        vim.keymap.set('n', '<leader>ll', function()
                            vim.lsp.buf.format { async = true }
                        end, opts('format'))
                    end
                    --
                    local wk = require("which-key")
                    wk.register({
                        c = "LSP: code",
                        g = "LSP: jump",
                    }, { prefix = "<leader>" })
                end,
            })
        end,
    },
    {
        'williamboman/mason.nvim',
        build = ':MasonUpdate',
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig',
            'hrsh7th/nvim-cmp',
        },
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-vsnip',
            -- 'hrsh7th/cmp-emoji',
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    -- REQUIRED - you must specify a snippet engine
                    expand = function(args)
                        -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
                        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
                        -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
                    end,
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    -- { name = 'emoji' },
                    { name = 'path' },
                }, {
                    { name = 'buffer' },
                })
            })

            -- Set configuration for specific filetype.
            cmp.setup.filetype('gitcommit', {
                sources = cmp.config.sources({
                    { name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
                }, {
                    { name = 'buffer' },
                })
            })

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ '/', '?' }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                }),
                matching = { disallow_symbol_nonprefix_matching = false }
            })
        end
    },
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-textobjects",
            -- "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/nvim-treesitter-context",
            -- "nvim-treesitter/nvim-treesitter-highlight",
        },
        build = ":TSUpdate",
        config = function()
            require('treesitter-context').setup {
                max_lines = 4,
                multiline_threadshold = 1,
            }

            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
                sync_install = true,
                highlight = { enable = true },
                indent = { enable = true },
            })

            -- local max_filesize = 100 * 1024 -- 100 KB
            --
            -- -- Tree-sitterのハイライトを無効にする関数
            -- local function disable_treesitter_for_large_files(bufnr)
            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
            --     if ok and stats and stats.size > max_filesize then
            --         vim.api.nvim_buf_set_option(bufnr, 'syntax', 'OFF')
            --         vim.api.nvim_buf_set_option(bufnr, 'filetype', 'off')
            --         return true
            --     end
            --     return false
            -- end
            --
            -- -- BufReadPreイベントでTree-sitterのハイライトを無効にする
            -- vim.api.nvim_create_autocmd({ "BufReadPre" }, {
            --     callback = function(args)
            --         disable_treesitter_for_large_files(args.buf)
            --     end
            -- })
        end
    },
}
