vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.number = true
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'typescript',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'typescriptreact',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'vue',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'javascript',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'terraform',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'nix',
    callback = function()
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
})
local short_tab_langs = { 'yaml', 'json', 'markdown', 'vim', 'lua', 'sh', 'bash', 'zsh', 'fish' }
for _, lang in ipairs(short_tab_langs) do
    vim.api.nvim_create_autocmd('FileType', {
        pattern = lang,
        callback = function()
            vim.opt.tabstop = 2
            vim.opt.shiftwidth = 2
        end,
    })
end

-- package manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
    'plugins',
    {
        performance = {
            rtp = {
                disabled_plugins = {
                    'netrw',
                    'netrwPlugin',
                    'netrwSettings',
                    'netrwFileHandlers',
                },
            },
        },
        change_detection = { enabled = false },
    }
)

-- カラー
vim.cmd.colorscheme 'duskfox'
-- vim.cmd.colorscheme 'everforest'
vim.cmd.highlight 'Normal guibg=none ctermbg=none'
vim.cmd.highlight 'NonText guibg=none ctermbg=none'
vim.cmd.highlight 'LineNr guibg=none ctermbg=none'
vim.cmd.highlight 'Folded guibg=none ctermbg=none'
vim.cmd.highlight 'EndOfBuffer guibg=none ctermbg=none'
vim.cmd.highlight 'SignColumn guibg=none ctermbg=none'
vim.cmd.highlight 'NormalNC guibg=none ctermbg=none'
vim.cmd.highlight 'NvimTreeNormal guibg=none ctermbg=none'
vim.cmd.highlight 'NvimTreeNormalNC guibg=none ctermbg=none'
vim.cmd [[
  hi SmoothCursorRed guifg=#CCCCFF
  hi SmoothCursorOrange guifg=#C8A2C8
  hi SmoothCursorYellow guifg=#E0B0FF
  hi SmoothCursorGreen guifg=#E6E6FA
  hi SmoothCursorAqua guifg=#8A2BE2
  hi SmoothCursorBlue guifg=#800080
  hi SmoothCursorPurple guifg=#800080
  hi SmoothCursor guifg=#CCCCFF
]]

-- キーマップ
-- vim.keymap.set('', '<C-Q>', '<C-\\><C-n>:qa!<CR>', { desc = 'Force quit vim' })
-- vim.keymap.set({ 'n', 'v', 'o' }, '<C-j>', '<C-f>zz', { desc = 'Down 1 page' })
-- vim.keymap.set({ 'n', 'v', 'o' }, '<C-k>', '<C-b>zz', { desc = 'Up 1 page' })
vim.keymap.set({ 'n', 'v', 'o' }, '<Up>', '<C-u>zz', { desc = 'Up half page' })
vim.keymap.set({ 'n', 'v', 'o' }, '<Down>', '<C-d>zz', { desc = 'Down half page' })
-- vim.keymap.set({ 'n', 'v', 'o' }, '<Right>', '$', { desc = 'end of line' })
-- vim.keymap.set({ 'n', 'v', 'o' }, '<Left>', '^', { desc = 'start of line' })
vim.keymap.set('n', '<leader>wj', '<C-w>w', { desc = 'Next Window' })
vim.keymap.set('n', '<leader>wk', '<C-w>p', { desc = 'Previous Window' })
vim.keymap.set({ 'n', 'v' }, 'gp', '"0p', { desc = 'Paste from yank register' })
vim.keymap.set({ 'n', 'v' }, 'gP', '"0P', { desc = 'Paste from yank register' })
-- vim.keymap.set("t", "<ESC><ESC>", "<CMD>q<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "gx", [[:silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>]], { noremap = true, silent = true })
vim.keymap.set("n", 'gx', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]],
    { noremap = true, silent = true })
-- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit Terminal Mode' })
vim.keymap.set("i", "jj", "<ESC>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sv", "<CMD>vsplit<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>sh", "<CMD>split<CR>", { noremap = true, silent = true })

-- ghqでリポジトリを移動するカスタム関数の定義
function ghq_list_telescope()
    -- `ghq list`コマンドを実行し、その結果を変数に格納
    local handle = io.popen('ghq list')
    if handle == nil then
        print('ghq list not found')
        return
    end
    local result = handle:read("*a")
    handle:close()

    -- 出力を行単位に分割
    local repos = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(repos, line)
    end

    -- `ghq root`コマンドを実行してルートディレクトリを取得
    local handle_root = io.popen('ghq root')
    if handle_root == nil then
        print('ghq root not found')
        return
    end
    local root = handle_root:read("*a"):gsub("%s+", "") -- 余分な空白を削除
    handle_root:close()

    -- `telescope`を使ってリポジトリを選択
    require('telescope.pickers').new({}, {
        prompt_title = "Select Repository",
        finder = require('telescope.finders').new_table {
            results = repos,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end
        },
        sorter = require('telescope.config').values.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            local actions = require('telescope.actions')
            local action_state = require('telescope.actions.state')
            actions.select_default:replace(function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                local full_path = root .. '/' .. selection.value
                vim.cmd('cd ' .. full_path)
                local nvim_tree = require("nvim-tree")
                nvim_tree.change_dir(full_path)
                print('Changed directory to ' .. full_path)
            end)
            return true
        end
    }):find()
end

vim.api.nvim_set_keymap('n', '<leader>tq', [[<cmd>lua ghq_list_telescope()<CR>]], { noremap = true, silent = true })

-- LSP

-- diagnosticの表示設定など
vim.diagnostic.config({
    virtual_text = {
        prefix = '●', -- これは好みで設定
        source = "if_many", -- 診断のソースを表示します
    },
    underline = true,
    signs = true,
    update_in_insert = false, -- 挿入モードでの更新は行わない
})

-- プラグインの設定
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-lspconfig").setup_handlers {
    function(server_name)
        local opts = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
        }
        if server_name == "tsserver" then
            opts.on_attach = function(client, bufnr)
                client.resolved_capabilities.document_formatting = false
                client.resolved_capabilities.document_range_formatting = false
            end
        end
        require("lspconfig")[server_name].setup({ opts = opts })
    end,
}

-- 各LSPの設定

local lspconfig = require('lspconfig')

lspconfig.basedpyright.setup {
    settings = {
        basedpyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
            analysis = {
                -- Ignore all files for analysis to exclusively use Ruff for linting
                -- ignore = { '*' },
                autoImportCompletions = true,
            },
        },
    },
}

lspconfig.ruff.setup {
    on_attach = function(client, bufnr)
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
    end,
    settings = {
        ruff = {
            -- args
        },
    },
}

lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = function(client, bufnr)
    -- デバッグ用のログ出力
    vim.lsp.set_log_level("debug")
  end,
}

-- local on_attach = function(client, bufnr)
--   if client.name == 'ruff_lsp' then
--     -- Disable hover in favor of Pyright
--     client.server_capabilities.hoverProvider = false
--   end
-- end
--
-- lspconfig.ruff_lsp.setup {
--   on_attach = on_attach,
-- }

-- -- pyrightの設定
-- require('lspconfig').pyright.setup {
--   settings = {
--     pyright = {
--       -- Using Ruff's import organizer
--       disableOrganizeImports = true,
--     },
--     python = {
--       analysis = {
--         -- Ignore all files for analysis to exclusively use Ruff for linting
--         ignore = { '*' },
--       },
--     },
--   },
-- }

-- lspconfig.volar.setup({
--     cmd = { 'volar-server', '--stdio' },
--     filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact', 'vue' },
-- })

-- lspconfig.tsserver.setup({
--     on_attach = function(client, bufnr)
--         client.resolved_capabilities.document_formatting = false
--         client.resolved_capabilities.document_range_formatting = false
--     end
-- })

-- lspconfig.pylsp.setup({
--     settings = {
--         pylsp = {
--             plugins = {
--                 pycodestyle = { enabled = false },
--                 pydocstyle = { enabled = false },
--                 pyflakes = { enabled = false },
--                 mccabe = { enabled = false },
--                 -- rope_completion = { enabled = false },
--                 -- yapf = { enabled = false },
--                 -- pylint = { enabled = false },
--                 flake8 = { enabled = false },
--                 -- isort = { enabled = false },
--                 -- jedi_completion = { enabled = false },
--                 -- jedi_hover = { enabled = false },
--                 -- jedi_references = { enabled = false },
--                 -- jedi_signature_help = { enabled = false },
--                 -- jedi_symbols = { enabled = false },
--                 -- preload = { enabled = false },
--                 -- autopep8 = { enabled = false },
--                 ruff = { enabled = true },
--                 mypy = {
--                     enabled = true,
--                     live_mode = true,
--                     strict = true
--                 },
--             },
--         },
--     },
-- })
