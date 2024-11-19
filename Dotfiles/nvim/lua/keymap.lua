-- Common
local opts = {
    noremap = true,      -- non-recursive
    silent = true,       -- do not show message
    desc = "",           -- describe
}
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


-----------------
-- Normal mode --
-----------------

vim.keymap.set('n', 'H', '^', opts)
vim.keymap.set('n', 'L', '$', opts)

vim.keymap.set('n', '<Leader>s', '<C-w>s', opts)
vim.keymap.set('n', '<Leader>v', '<C-w>v', opts)
vim.keymap.set('n', '<C-h>', '<C-w>h', opts)
vim.keymap.set('n', '<C-j>', '<C-w>j', opts)
vim.keymap.set('n', '<C-k>', '<C-w>k', opts)
vim.keymap.set('n', '<C-l>', '<C-w>l', opts)

-- https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk
vim.keymap.set("n", "j", [[v:count ? 'j' : 'gj' ]], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? 'k' : 'gk' ]], { noremap = true, expr = true })


-----------------
-- Visual mode --
-----------------

vim.keymap.set('v', '<', '<gv', opts)
vim.keymap.set('v', '>', '>gv', opts)


--vim.cmd([[
--"ctrl A to  move to line start when in command mode like in iterm2
--"ctrl E to move to line end when in command mode like in iterm2
--cnoremap <C-a> <Home>
--cnoremap <C-e> <End>
--inoremap <D-v> <c-r>+
--nnoremap <D-v> "+p
--cnoremap <D-v> <c-r>+
--]])
