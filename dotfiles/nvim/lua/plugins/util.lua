return {
    -- session
    {
        "rmagatti/auto-session",
        lazy = false,
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { "<leader>sf", "<cmd>SessionSearch<CR>", desc = "Session Search" },
            { "<leader>ss", "<cmd>SessionSave<CR>",   desc = "Session Save" },
            { "<leader>sq", "<cmd>qa<CR>",            desc = "Quit All" },
        },
        opts = {
            auto_save = false,
            -- auto_restore_last_session = false,
            -- allowed_dirs = { "/some/dir/", "/projects/*" },
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
        }
    },
}
