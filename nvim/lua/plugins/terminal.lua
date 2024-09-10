return {
    -- {
    --     'voldikss/vim-floaterm',
    --     config = function()
    --         -- require("vim-floaterm").setup({})
    --         vim.keymap.set("t", "jk", "<C-\\><C-n>", { noremap = true, silent = true })
    --     end,
    -- },
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function()
            require("toggleterm").setup {
                open_mapping = [[<c-\>]],
                -- size = 20 | function(term)
                --     if term.direction == "horizontal" then
                --         return 15
                --     elseif term.direction == "vertical" then
                --         return vim.o.columns * 0.4
                --     end
                -- end,
                -- open_mapping = [[<c-\>]],
            }

            vim.g.toggleterm_terminal_mapping = "<C-t>"
            vim.g.toggleterm_direction = "float"
            vim.g.toggleterm_float = {
                border = "single",
                width = 0.8,
                height = 0.8,
            }
            vim.keymap.set("t", "<C-q>", "<C-\\><C-n>", { noremap = true, silent = true })
            vim.keymap.set({ "n", "t" }, "<leader>/", "<CMD>ToggleTerm<CR>",
                { noremap = true, silent = true })

            local on_open = function(term)
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<ESC><ESC>", "i<cmd>close<CR>",
                    { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC><ESC>",
                    "<cmd>close<CR>", { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<C-S-e>", "i<cmd>close<CR>",
                    { noremap = true, silent = true })
                vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<C-S-e>",
                    "<cmd>close<CR>", { noremap = true, silent = true })
            end

            -- Custom terminals
            local Terminal = require("toggleterm.terminal").Terminal
            UTERM = Terminal:new({
                direction = "float",
                hidden = true,
                on_open = on_open,
            })

            function G_uterm_toggle()
                UTERM.direction = "float"
                UTERM:toggle()
            end

            local iterm = Terminal:new({
                direction = "float",
                hidden = true,
                on_open = on_open,
            })

            function G_iterm_toggle()
                iterm.direction = "float"
                iterm:toggle()
            end

            local lazygit_term = Terminal:new({
                cmd = "lazygit",
                direction = "float",
                hidden = true,
                on_open = function(term)
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "<ESC><ESC>", "i<cmd>close<CR>",
                        { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "<ESC><ESC>",
                        "<cmd>close<CR>", { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "i<cmd>close<CR>",
                        { noremap = true, silent = true })
                    vim.api.nvim_buf_set_keymap(term.bufnr, "t", "q",
                        "<cmd>close<CR>", { noremap = true, silent = true })
                end,
            })

            function G_lazygit_term_toggle()
                lazygit_term:toggle()
            end

            local function list_terminals()
                local terminals = {}

                -- 全てのバッファを取得
                for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    -- バッファのファイルタイプが'terminal'であるか確認
                    if vim.api.nvim_buf_get_option(buf, 'buftype') == 'terminal' then
                        table.insert(terminals, buf)
                    end
                end

                return terminals
            end

            function G_terminals()
                local terminals = list_terminals()
                print("Terminals: " .. #terminals)
                for _, term in ipairs(terminals) do
                    print(vim.api.nvim_buf_get_var(term, "toggle_number"))
                end
            end

            function G_get_tail(term)
                local bufnr = term.bufnr
                if bufnr == nil then
                    print("No terminal buffer found")
                    return
                end
                local job_id = vim.fn.getbufvar(bufnr, 'term_job_id', -1)

                -- job IDからプロセスIDを取得
                if job_id ~= -1 then
                    local pid = vim.fn.jobpid(job_id)
                    print("PID: " .. pid)

                    -- プロセス情報を取得（Unix系システムの場合）
                    local process_info = vim.fn.system('ps -p ' .. pid)
                    print(process_info)
                else
                    print("No terminal job associated with buffer " .. bufnr)
                end
            end

            vim.api.nvim_set_keymap('n', "<leader>r", "<cmd>lua G_uterm_toggle()<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', "<leader>e", "<cmd>lua G_iterm_toggle()<CR>", { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', "<leader>lg", "<cmd>lua G_lazygit_term_toggle()<CR>",
                { noremap = true, silent = true })

            -- ターミナルジョブが実行中かどうかを確認する関数
            local function is_terminal_running(bufnr)
                local channel = vim.b[bufnr].terminal_job_id
                if channel then
                    local job_status = vim.fn.jobwait({ channel }, 0)[1]
                    return job_status == -1
                end
                return false
            end

            -- ステータスラインにターミナルの状態を表示する関数
            function G_terminal_statusline()
                local bufnr = UTERM.bufnr
                local term_title = vim.b[bufnr].term_title or ''
                local running = is_terminal_running(bufnr) and 'Running' or 'Stopped'
                return string.format('%s [%s]', term_title, running)
            end

            -- ターミナルが開かれたときにステータスラインを設定
            vim.api.nvim_create_autocmd('TermOpen', {
                callback = function()
                    vim.opt_local.statusline = '%!v:lua.G_terminal_statusline()'
                end
            })

            -- ターミナルが閉じられたときに終了ステータスを表示
            vim.api.nvim_create_autocmd('TermClose', {
                callback = function(event)
                    local status = event.data.status
                    vim.notify('Terminal exited with status ' .. status)
                end
            })
        end,
    },
}
