return {
    -- fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<Leader>ff", "<cmd>Telescope find_files<CR>",                { desc = "find files" } },
            { "<Leader>fg", "<cmd>Telescope live_grep<CR>",                 { desc = "grep file" } },
            { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "search current buffer" } },
        },
    },
    --  file explorer
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<Leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-tree explorer" } },
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    -- session
    {
        "rmagatti/auto-session",
        lazy = false,
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { "<leader>ss", "<cmd>SessionSearch<CR>", desc = "Session Search" },
            { "<leader>sw", "<cmd>SessionSave<CR>",   desc = "Session Save" },
            { "<leader>sq", "<cmd>qa<CR>",            desc = "Quit All" },
        },
        opts = {
            auto_save = false,
            -- auto_restore_last_session = false,
            -- allowed_dirs = { "/some/dir/", "/projects/*" },
            suppressed_dirs = { "/", "~/", "~/Projects", "~/Downloads" },
        }
    },
}
