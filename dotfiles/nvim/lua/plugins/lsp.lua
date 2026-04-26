return {
    -- lsp installer
    {
        "williamboman/mason.nvim",
        cmd = { "Mason", "MasonInstall" },
        build = ":MasonUpdate",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗"
                    }
                }
            })
        end,
    },
    -- lsp
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            vim.lsp.log.set_level("error")

            local on_attach = function(_, bufnr)
                local bufopts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "code action" }))
                vim.keymap.set("n", "<leader>cd", vim.lsp.buf.declaration, vim.tbl_extend("force", bufopts, { desc = "goto declaration" }))
                vim.keymap.set("n", "<leader>cD", vim.lsp.buf.definition, vim.tbl_extend("force", bufopts, { desc = "goto definition" }))
                vim.keymap.set("n", "<leader>cK", vim.lsp.buf.hover, vim.tbl_extend("force", bufopts, { desc = "hover documentation" }))
                vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, vim.tbl_extend("force", bufopts, { desc = "goto implementation" }))
                vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "rename" }))
                vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references, vim.tbl_extend("force", bufopts, { desc = "goto references" }))
                vim.keymap.set("n", "<leader>cs", vim.lsp.buf.document_symbol, vim.tbl_extend("force", bufopts, { desc = "document symbol" }))
                vim.keymap.set("n", "<leader>cf", function()
                    vim.lsp.buf.format({ async = true })
                end, vim.tbl_extend("force", bufopts, { desc = "format document" }))
            end

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "lua_ls",
                    "pylsp",
                    "gopls",
                    "marksman",
                },
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,
                },
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
    -- formatter
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        opts = {},
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    bash = { "shfmt" },
                    go = { "goimports", "gofmt" },
                    lua = { "stylua" },
                    -- rust = { "rustfmt" }, -- rustup component add rustfmt
                    python = { "isort", "black" },
                    javascript = { "prettierd", "prettier", stop_after_first = true },
                    json = { "prettier" },
                    markdown = { "prettier" },
                    toml = { "taplo" },
                    yml = { "prettier" },
                    yaml = { "prettier" },
                },
                format_on_save = {
                    lsp_format = "fallback",
                    timeout_ms = 500,
                },
            })
        end,
    },
}
