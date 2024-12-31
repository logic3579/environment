local map = vim.keymap.set
local opts = { remap = false, silent = true }


-- better line start/end
map("n", "H", "^", opts)
map("n", "L", "$", opts)

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- windows
map("n", "<leader>ws", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- clear hlsearch
map("n", "<leader><Esc>", "<cmd>nohlsearch<cr>")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- diagnostic
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous Diagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next Diagnostic message" })
map("n", "<leader>dof", vim.diagnostic.open_float, { desc = "Show diagnostics message" })
map("n", "<leader>dqf", vim.diagnostic.setloclist, { desc = "Open diagnostics Quickfix" })

-- tabs
map("n", "<leader><tab>k", "<C-o>", { desc = "Previous Tab", remap = false })
map("n", "<leader><tab>j", "<C-i>", { desc = "Next Tab", remap = false })
--map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
--map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
--map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
--map("n", "<leader><tab>n", "<cmd>tabnew<cr>", { desc = "New Tab" })
--map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
