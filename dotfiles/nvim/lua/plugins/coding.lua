return {
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
                    json = { "prettier" },
                    yml = { "prettier" },
                    yaml = { "prettier" },
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
    -- neovim lua development
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- editing support
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({
                fast_wrap = {},
                disable_filetype = { "TelescopePrompt", "vim" },
            })
        end,
    },
    -- completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter" },
        dependencies = {
            "neovim/nvim-lspconfig",
            "hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
            "hrsh7th/cmp-buffer",   -- buffer auto-completion
            "hrsh7th/cmp-path",     -- path auto-completion
            "hrsh7th/cmp-cmdline",  -- cmdline auto-completion
            "L3MON4D3/LuaSnip",     -- for luasnip
        },
        config = function()
            require("config.mycmpconfig")
        end,
    },
}
