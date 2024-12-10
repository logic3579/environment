return {
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
}
