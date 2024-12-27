return {
    -- powerful comment
    {
        "numToStr/Comment.nvim",
        opts = {
            -- add any options here
        },
        config = function()
            require("Comment").setup()
        end
    },
    -- fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.8",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<Leader>ff", "<cmd>Telescope find_files<CR>", { desc = "find files" } },
            { "<Leader>fg", "<cmd>Telescope live_grep<CR>",  { desc = "grep file" } },
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
    -- git support
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "<leader>gp", function() require("gitsigns").nav_hunk("prev") end,     desc = "Prev Hunk"},
            { "<leader>gn", function() require("gitsigns").nav_hunk("next") end,     desc = "Next Hunk"},
        },
        config = function()
            require("gitsigns").setup {
                signcolumn = true,
                numhl = true,
                linehl = false,
                word_diff = true,
            }
        end,
    },
    -- show keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "classic",
            spec = {
                { "<leader>c", group = " Code",              mode = { "n", "x" } },
                { "<leader>d", group = " Debug | Diagnosis", mode = { "n", "v" } },
                { "<leader>f", group = " Find | File" },
                { "<leader>s", group = " Session" },
                { "<leader>w", group = " windows" },
                -- { "<leader>W", group = "Workspace" },
                -- { "<leader>t", group = "Toggle" },
                { "<leader>g", group = " Git" },
            },
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
