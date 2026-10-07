vim.lsp.log.set_level("error")

vim.lsp.config("bashls", {
	cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "bash" },
	root_markers = { ".git" },
	settings = { bashIde = { globPattern = "*@(.sh|.inc|.bash|.command)" } },
})

vim.lsp.config("lua_ls", {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	on_init = function(client)
		local root = client.config.root_dir
		if root and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
			return
		end
		-- Neovim's runtime includes its Lua API and vim.uv type definitions.
		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
			runtime = { version = "LuaJIT" },
			workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
		})
	end,
	settings = { Lua = {} },
})

vim.lsp.config("pylsp", {
	cmd = { "pylsp" },
	filetypes = { "python" },
	root_markers = { { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt" }, ".git" },
})

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork" },
	root_markers = { "go.work", "go.mod", ".git" },
})

-- TypeScript 7 ships an LSP server; the older tsserver wrapper requires TS <= 6.
vim.lsp.config("tsc", {
	cmd = { "tsc", "--lsp", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	root_markers = { { "tsconfig.json", "jsconfig.json", "package.json" }, ".git" },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("native_lsp", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)
		if not client then
			return
		end

		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, event.buf)
		end

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
		end
		map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
		map("n", "<leader>cd", vim.lsp.buf.declaration, "Go to declaration")
		map("n", "<leader>cD", vim.lsp.buf.definition, "Go to definition")
		map("n", "<leader>cK", vim.lsp.buf.hover, "Hover documentation")
		map("n", "<leader>ci", vim.lsp.buf.implementation, "Go to implementation")
		map("n", "<leader>cn", vim.lsp.buf.rename, "Rename symbol")
		map("n", "<leader>cR", vim.lsp.buf.references, "Find references")
		map("n", "<leader>cs", vim.lsp.buf.document_symbol, "Document symbols")
	end,
})

vim.lsp.enable({ "bashls", "lua_ls", "pylsp", "gopls", "tsc" })
