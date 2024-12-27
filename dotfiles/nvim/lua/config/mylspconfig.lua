local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.set_log_level("error")

local on_attach = function(client, bufnr)
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    --vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = "Code Action" }))
    vim.keymap.set('n', '<leader>cd', vim.lsp.buf.declaration, vim.tbl_extend('force', bufopts, { desc = "Go to Declaration" }))
    vim.keymap.set('n', '<leader>cD', vim.lsp.buf.definition, vim.tbl_extend('force', bufopts, { desc = "Go to Definition" }))
    vim.keymap.set('n', '<leader>cK', vim.lsp.buf.hover, vim.tbl_extend('force', bufopts, { desc = "Show Hover Information" }))
    vim.keymap.set('n', '<leader>ci', vim.lsp.buf.implementation, vim.tbl_extend('force', bufopts, { desc = "Go to Implementation" }))
    vim.keymap.set('n', '<leader>crf', vim.lsp.buf.references, vim.tbl_extend('force', bufopts, { desc = "Show References" }))
    vim.keymap.set('n', '<leader>crn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = "Rename Symbol" }))
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<leader>cwa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>cwr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>cwl', function()
    --    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts)
    --vim.keymap.set('n', '<leader>cD', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>cf", function()
        vim.lsp.buf.format({ async = true })
    end, vim.tbl_extend('force', bufopts, { desc = "Format Document" }))
end

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
