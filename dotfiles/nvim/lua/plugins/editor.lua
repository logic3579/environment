return {
    -- fuzzy finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        cmd = "Telescope",
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { "<Leader>ff",  ":Telescope find_files<CR>", { desc = "find files" } },
            { "<Leader>fg",  ":Telescope live_grep<CR>",  { desc = "grep file" } },
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
            }
        end,
    },
    --  nvim-treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    "bash",
                    "go",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "python",
                    "yaml",
                    "vim",
                },
                sync_install = false,
                auto_install = true,
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
}
