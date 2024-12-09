return {
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
        "akinsho/bufferline.nvim",
        version = "*",
        keys = {
            { "<M-h>", ":BufferLineCyclePrev<CR>", { desc = "toggle next tab" } },
            { "<M-l>", ":BufferLineCycleNext<CR>", { desc = "toggle previous tab" } },
        },
        config = function()
            require("bufferline").setup {
                indicator = {
                    icon = "▎",
                    style = "underline",
                },
                options = {
                    offsets = {
                        {
                            filetype = "NvimTree",
                            text = "File Explorer",
                            text_align = "left",
                            separator = true,
                        }
                    }
                }
            }
        end,
    },
}
