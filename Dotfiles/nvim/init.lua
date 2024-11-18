local safeRequire = require("lib").safeRequire

safeRequire("autocmd")
safeRequire("keymap")
safeRequire("lazynvim")
safeRequire("option")

-- plugins
-- safeRequire(plugins.xxx)


-- color scheme
local colorscheme = 'solarized'
local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
    vim.notify('colorscheme ' .. colorscheme .. ' not found!')
    return
end
