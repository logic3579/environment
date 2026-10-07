vim.opt.autocomplete = true
vim.opt.autocompletedelay = 100
vim.opt.complete = { "o", ".", "w", "b" }
vim.opt.completeopt = { "menu", "menuone", "noselect", "popup", "fuzzy" }
vim.opt.pumborder = "rounded"

vim.keymap.set("i", "<C-Space>", "<C-n>", { desc = "Trigger completion" })
vim.keymap.set({ "i", "s" }, "<Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-n>"
	elseif vim.snippet.active({ direction = 1 }) then
		return "<Cmd>lua vim.snippet.jump(1)<CR>"
	end
	return "<Tab>"
end, { expr = true, silent = true, desc = "Next completion / snippet placeholder" })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if vim.fn.pumvisible() == 1 then
		return "<C-p>"
	elseif vim.snippet.active({ direction = -1 }) then
		return "<Cmd>lua vim.snippet.jump(-1)<CR>"
	end
	return "<S-Tab>"
end, { expr = true, silent = true, desc = "Previous completion / snippet placeholder" })

-- Return must use CTRL-Y so native LSP completion applies snippets and imports.
vim.keymap.set("i", "<CR>", function()
	if vim.fn.pumvisible() == 1 then
		local keys = vim.fn.complete_info({ "selected" }).selected == -1 and "<C-n><C-y>" or "<C-y>"
		return vim.api.nvim_replace_termcodes(keys, true, false, true)
	end
	return require("nvim-autopairs").autopairs_cr()
end, { expr = true, replace_keycodes = false, desc = "Accept completion / insert newline" })
