return {
    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        cmd = "Telescope",
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { "<Leader>ff", ":Telescope find_files<CR>", { desc = "find files" } },
            { "<Leader>fg", ":Telescope live_grep<CR>",  { desc = "grep file" } },
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
            { "<Leader>m", ":NvimTreeToggle<CR>", { desc = "toggle nvim-tree" } },
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    -- git support
    {
        "lewis6991/gitsigns.nvim",
        -- keys = {
        --     {"<leader>hs", ":Gitsigns stage_hunk<CR>"},
        -- },
        config = function()
            require("gitsigns").setup {
                signcolumn = true,
                numhl = true,
                linehl = false,
                word_diff = true,
            }
        end,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    }
}
