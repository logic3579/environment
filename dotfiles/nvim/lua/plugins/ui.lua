return {
    -- tabline
    {
        "akinsho/bufferline.nvim",
        version = "*",
        keys = {
            { "<M-h>", ":BufferLineCyclePrev<CR>", { desc = "toggle next tab" } },
            { "<M-l>", ":BufferLineCycleNext<CR>", { desc = "toggle previous tab" } },
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
