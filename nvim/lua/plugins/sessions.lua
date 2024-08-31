return {
    {
        'rmagatti/auto-session',
        dependencies = {
            'nvim-telescope/telescope.nvim', -- Only needed if you want to use sesssion lens
        },
        config = function()
            require('auto-session').setup({
                auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
                pre_restore_cmds = { 'lua CloseSpecificBuffers()' },
            })

            -- 特定のディレクトリのバッファを閉じる関数
            function CloseSpecificBuffers()
                local buffers = vim.api.nvim_list_bufs()
                for _, buf in ipairs(buffers) do
                    local buf_name = vim.api.nvim_buf_get_name(buf)
                    if string.match(buf_name, "^/path/to/your/directory") then
                        vim.api.nvim_buf_delete(buf, { force = true })
                    end
                end
            end

            -- セッションのタイムスタンプを保存するための変数
            local session_timestamp = nil

            -- セッションを保存する関数
            local function save_session()
                session_timestamp = os.time()
                vim.cmd('SaveSession')
            end

            -- セッションを復活させる関数
            local function restore_session()
                local current_time = os.time()
                if session_timestamp and (current_time - session_timestamp <= 300) then -- 300秒（5分）以内
                    vim.cmd('RestoreSession')
                else
                    -- セッションを破棄する
                    vim.cmd('DeleteSession')
                end
            end
            --
            -- -- Neovimの終了時にセッションを保存
            -- vim.api.nvim_create_autocmd('VimLeavePre', {
            --     callback = save_session,
            -- })
            --
            -- -- Neovimの起動時にセッションを復活
            -- vim.api.nvim_create_autocmd('VimEnter', {
            --     callback = restore_session,
            -- })
        end,
    },
}
