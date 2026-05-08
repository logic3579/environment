vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true

local opt = vim.opt

opt.autoread = true
opt.autowrite = true
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.foldlevel = 99
opt.ignorecase = true
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- Wrap lines at convenient points
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- show absolute line number
opt.relativenumber = true -- show relative line number
opt.ruler = false -- Disable the default ruler
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions" -- auto-session plugin
opt.shiftround = true -- Round indent
opt.shiftwidth = 4 -- Size of an indent
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = 4 -- number of spacesin tab when editing
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
--opt.statusline=\ %F%m%r%h\ Format:\%{&fileformat}\ Line:\ %l\ Column:\ %c\ Percent:\ %p%%
opt.tabstop = 4 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
--opt.wrap = false -- Disable line wrap

-- Neovide-specific options
if vim.g.neovide then
	-- Treat macOS Option key as Meta so mappings like <M-p>/<M-n> work
	vim.g.neovide_input_macos_option_key_is_meta = "both"

	-- GUI font (terminal nvim ignores guifont entirely)
	vim.o.guifont = "MesloLGMDZ Nerd Font Mono:h17"

	-- Dynamic zoom via scale factor
	vim.g.neovide_scale_factor = 1.0
	local function change_scale(delta)
		vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
	end
	vim.keymap.set({ "n", "i" }, "<D-=>", function()
		change_scale(1.1)
	end, { desc = "Neovide zoom in" })
	vim.keymap.set({ "n", "i" }, "<D-->", function()
		change_scale(1 / 1.1)
	end, { desc = "Neovide zoom out" })
	vim.keymap.set({ "n", "i" }, "<D-0>", function()
		vim.g.neovide_scale_factor = 1.0
	end, { desc = "Neovide zoom reset" })

	-- Workaround for reversed IME punctuation logic in winit on macOS (winit#3814)
	-- vim.g.neovide_input_ime = false
end
