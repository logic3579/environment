return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "x" },
				desc = "Format document / selection",
			},
		},
		opts = {
			formatters_by_ft = {
				sh = { "shfmt" },
				bash = { "shfmt" },
				go = { "gofmt" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				python = { "ruff_fix", "ruff_format" },
				toml = { "taplo" },
				yaml = { "prettier" },
			},
			format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
		},
	},
}
