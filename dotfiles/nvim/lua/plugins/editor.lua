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
    -- git support
    {
        "lewis6991/gitsigns.nvim",
        keys = {
            { "<leader>gk", function() require("gitsigns").preview_hunk() end,   desc = "Preview Hunk" },
            { "<leader>gp", function() require("gitsigns").nav_hunk("prev") end, desc = "Prev Hunk" },
            { "<leader>gn", function() require("gitsigns").nav_hunk("next") end, desc = "Next Hunk" },
        },
        config = function()
            require("gitsigns").setup {
                signs = {
                    add          = { text = "+" },
                    change       = { text = "~" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                signs_staged = {
                    add          = { text = "+" },
                    change       = { text = "~" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                    untracked    = { text = "┆" },
                },
                signs_staged_enable = true,
                signcolumn = true,
                numhl = true,
                linehl = false,
                word_diff = true,
            }
        end,
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
        },
        keys = {
            { "<leader>gg", function() require("neogit").open() end,             desc = "Neogit Status" },
            { "<leader>gc", function() require("neogit").open({ "commit" }) end, desc = "Neogit Commit popup" },
        },
        config = function()
            local neogit = require("neogit")
            neogit.setup({
                kind = "auto",
                integrations = {
                    diffview = true,
                    telescope = true,
                },
            })
        end,
    },
    -- formatter
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    lua = { "stylua" },
                    go = { "goimports", "gofmt" },
                    -- rust = { "rustfmt", lsp_format = "fallback" },
                    python = { "isort", "black" },
                    markdown = { "prettier" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                },
                format_on_save = {
                    lsp_format = "fallback",
                    timeout_ms = 500,
                },
                format_after_save = {
                    lsp_format = "fallback",
                },
            })
        end,
    },
    -- show keybindings
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "classic",
            spec = {
                { "<leader>c",     group = " Code",              mode = { "n", "x" } },
                { "<leader>d",     group = " Debug | Diagnosis", mode = { "n", "v" } },
                { "<leader>f",     group = " Find | File" },
                { "<leader>g",     group = " Git" },
                { "<leader>s",     group = " Session" },
                { "<leader><tab>", group = " Tab" },
                { "<leader>w",     group = " Windows" },
                -- { "<leader>t", group = " Toggle" },
                -- { "<leader>W", group = " Workspace" },
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
