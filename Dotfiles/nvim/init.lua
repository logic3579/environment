--vim.cmd("source ~/.config/nvim/.vimrc")
-- lib
local safeRequire = require("lib").safeRequire

safeRequire("autocmd")
safeRequire("keymap")
safeRequire("option")
-- lazy.vim
safeRequire("lazynvim")

-- plugins
-- safeRequire(plugins.xxx)


-- color scheme
local colorscheme = 'solarized'
local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
