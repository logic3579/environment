return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        cmd = "Neotree",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        }
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
        }
    },
}
