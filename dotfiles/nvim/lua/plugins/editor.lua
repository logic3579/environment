return {
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        keys = {
            { "<Leader>m", ":NvimTreeToggle<CR>", { desc = "nvim-tree toggle" } },
        },
        config = function()
            require("nvim-tree").setup {}
        end,
    },
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        cmd = "Telescope",
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { "<Leader>p",  ":Telescope find_files<CR>", { desc = "find files" } },
            { "<Leader>P",  ":Telescope live_grep<CR>",  { desc = "grep file" } },
            { "<Leader>rs", ":Telescope resume<CR>",     { desc = "resume" } },
        },
    },
}
