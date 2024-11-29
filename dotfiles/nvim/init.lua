--vim.cmd("source ~/.config/nvim/.vimrc")

local safeRequire = require("config.lib").safeRequire
safeRequire("config.option")
safeRequire("config.keymap")
safeRequire("config.autocmd")
safeRequire("config.lazynvim") -- lazy.vim


-- color scheme
local colorscheme = 'solarized'
local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
