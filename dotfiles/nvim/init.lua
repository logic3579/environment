--vim.cmd("source ~/.config/nvim/.vimrc")

local safeRequire = require("config.lib").safeRequire
safeRequire("config.option")
safeRequire("config.keymap")
safeRequire("config.autocmd")
safeRequire("config.lazynvim") -- lazy.vim

-- awesome-neovim
-- https://github.com/rockerBOO/awesome-neovim
