-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = { "*" },
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})
