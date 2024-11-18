-- highlight after copy
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = { "*" },
    callback = function()
        vim.highlight.on_yank({
            timeout = 30,
        })
    end,
})
