return {
	-- lsp installer
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
		end,
	},
	-- lsp
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"b0o/SchemaStore.nvim", -- JSON/YAML schema catalog for jsonls/yamlls
		},
		config = function()
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			vim.lsp.log.set_level("error")

			local on_attach = function(_, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }
				vim.keymap.set(
					"n",
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", bufopts, { desc = "code action" })
				)
				vim.keymap.set(
					"n",
					"<leader>cd",
					vim.lsp.buf.declaration,
					vim.tbl_extend("force", bufopts, { desc = "goto declaration" })
				)
				vim.keymap.set(
					"n",
					"<leader>cD",
					vim.lsp.buf.definition,
					vim.tbl_extend("force", bufopts, { desc = "goto definition" })
				)
				vim.keymap.set(
					"n",
					"<leader>cK",
					vim.lsp.buf.hover,
					vim.tbl_extend("force", bufopts, { desc = "hover documentation" })
				)
				vim.keymap.set(
					"n",
					"<leader>ci",
					vim.lsp.buf.implementation,
					vim.tbl_extend("force", bufopts, { desc = "goto implementation" })
				)
				vim.keymap.set(
					"n",
					"<leader>cr",
					vim.lsp.buf.rename,
					vim.tbl_extend("force", bufopts, { desc = "rename" })
				)
				vim.keymap.set(
					"n",
					"<leader>cR",
					vim.lsp.buf.references,
					vim.tbl_extend("force", bufopts, { desc = "goto references" })
				)
				vim.keymap.set(
					"n",
					"<leader>cs",
					vim.lsp.buf.document_symbol,
					vim.tbl_extend("force", bufopts, { desc = "document symbol" })
				)
				vim.keymap.set("n", "<leader>cf", function()
					vim.lsp.buf.format({ async = true })
				end, vim.tbl_extend("force", bufopts, { desc = "format document" }))
			end

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
				handlers = {
					function(server_name)
						lspconfig[server_name].setup({
							capabilities = capabilities,
							on_attach = on_attach,
						})
					end,
					["jsonls"] = function()
						lspconfig.jsonls.setup({
							capabilities = capabilities,
							on_attach = on_attach,
							settings = {
								json = {
									schemas = require("schemastore").json.schemas(),
									validate = { enable = true },
								},
							},
						})
					end,
					["yamlls"] = function()
						lspconfig.yamlls.setup({
							capabilities = capabilities,
							on_attach = on_attach,
							settings = {
								yaml = {
									-- disable built-in schema store; use SchemaStore.nvim instead
									schemaStore = {
										enable = false,
										url = "",
									},
									schemas = require("schemastore").yaml.schemas(),
									validate = true,
								},
							},
						})
					end,
				},
			})
		end,
	},
	-- completion
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp", -- lsp auto-completion
			"hrsh7th/cmp-buffer", -- buffer auto-completion
			"hrsh7th/cmp-path", -- path auto-completion
			"hrsh7th/cmp-cmdline", -- cmdline auto-completion
			"L3MON4D3/LuaSnip", -- for luasnip
		},
		config = function()
			require("config.mycmpconfig")
		end,
	},
	-- neovim lua development
	{
		"folke/lazydev.nvim",
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				-- See the configuration section for more details
				-- Load luvit types when the `vim.uv` word is found
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	-- mason tool installer (single source of truth for LSP/formatter/linter installs)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					-- LSP servers
					"bashls",
					"gopls",
					"jsonls",
					"lua_ls",
					"pylsp",
					"marksman",
					"taplo",
					"ts_ls",
					"yamlls",
					-- formatters / linters
					"prettier",
					"ruff",
					"shfmt",
					"stylua",
				},
				run_on_start = true,
			})
		end,
	},
	-- formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		opts = {},
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					bash = { "shfmt" },
					go = { "gofmt" },
					javascript = { "prettier" },
					json = { "prettier" },
					markdown = { "prettier" },
					lua = { "stylua" },
					python = { "ruff" },
					-- rust = { "rustfmt" },
					toml = { "taplo" },
					yaml = { "prettier" },
					yml = { "prettier" },
				},
				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 500,
				},
			})
		end,
	},
}
