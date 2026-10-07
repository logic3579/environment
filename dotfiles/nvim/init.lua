require("vim._core.ui2").enable({
	enable = true,
})
-- Set leaders and options before creating mappings or loading lazy.nvim.
require("core.option")
require("core.keymap")
require("core.autocmd")
require("core.completion")
require("plugins.lsp")
require("core.lazynvim")
