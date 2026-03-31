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
}
