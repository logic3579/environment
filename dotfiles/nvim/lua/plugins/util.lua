return {
    -- session
    {
        'rmagatti/auto-session',
        lazy = false,
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { '<leader>ss',  '<cmd>SessionSearch<CR>',         desc = 'Session search' },
            { '<leader>sw',  '<cmd>SessionSave<CR>',           desc = 'Save session' },
        },
        opts = {
            -- allowed_dirs = { '/some/dir/', '/projects/*' },
            suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
        }
    },
}
