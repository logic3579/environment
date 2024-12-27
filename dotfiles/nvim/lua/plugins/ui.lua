return {
    -- tabline
    {
        "akinsho/bufferline.nvim",
        version = "*",
        keys = {
            { "<M-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Toggle next tab" } },
            { "<M-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Toggle previous tab" } },
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
