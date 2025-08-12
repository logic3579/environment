return {
    -- tabline
    {
        "akinsho/bufferline.nvim",
        version = "*",
        keys = {
            { "<M-p>",                "<cmd>BufferLineCyclePrev<CR>", { desc = "Toggle previous tab" } },
            { "<M-n>",                "<cmd>BufferLineCycleNext<CR>", { desc = "Toggle next tab" } },
            { "<leader><tab><left>",  "<cmd>BufferLineMovePrev<CR>",  { desc = "Move tab left" } },
            { "<leader><tab><right>", "<cmd>BufferLineMoveNext<CR>",  { desc = "Move tab right" } },
        },
        config = function()
            require("bufferline").setup {
                options = {
                    indicator = {
                        icon = "▎",
                        style = "underline",
                    },
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
    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("lualine").setup {
                options = {
                    theme = "solarized_dark",
                },
                extensions = { "nvim-tree" },
            }
        end,
    },
}
