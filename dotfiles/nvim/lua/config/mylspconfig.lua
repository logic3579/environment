local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.set_log_level("error")

local on_attach = function(_, bufnr)
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", bufopts, { desc = "code action" }))
    vim.keymap.set("n", "<leader>cd", vim.lsp.buf.declaration,
        vim.tbl_extend("force", bufopts, { desc = "goto declaration" }))
    vim.keymap.set("n", "<leader>cD", vim.lsp.buf.definition,
        vim.tbl_extend("force", bufopts, { desc = "goto definition" }))
    vim.keymap.set("n", "<leader>cK", vim.lsp.buf.hover,
        vim.tbl_extend("force", bufopts, { desc = "hover documentation" }))
    vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation,
        vim.tbl_extend("force", bufopts, { desc = "goto inplementation" }))
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", bufopts, { desc = "rename" }))
    vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references,
        vim.tbl_extend("force", bufopts, { desc = "goto references" }))
    vim.keymap.set("n", "<leader>cs", vim.lsp.buf.document_symbol,
        vim.tbl_extend("force", bufopts, { desc = "document symbol" }))
    vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend("force", bufopts, { desc = "format document" }))
end

-- Bash
lspconfig.bashls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Lua
lspconfig.lua_ls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Python
lspconfig.pylsp.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Golang
lspconfig.gopls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- Markdown
lspconfig.marksman.setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "markdown" },
    root_dir = require("lspconfig.util").root_pattern(".git", ".marksman.toml"),
    single_file_support = true,
})
