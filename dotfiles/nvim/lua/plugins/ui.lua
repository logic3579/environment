return {
	-- QoL: vim.ui.input/notify UI, bigfile/quickfile perf guards
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			bigfile = { enabled = true },
			input = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			quickfile = { enabled = true },
			statuscolumn = { enabled = false },
			indent = { enabled = false },
		},
		keys = {
			{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Notification History" },
			{ "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss Notifications" },
		},
	},
	-- colorscheme
	{
		"maxmx03/solarized.nvim",
		lazy = false,
		priority = 1000,
		---@type solarized.config
		opts = {
			transparent = {
				enabled = true,
				pmenu = true,
				normal = true,
				normalfloat = true,
				neotree = true,
				nvimtree = true,
				whichkey = true,
				telescope = true,
				lazy = true,
			},
			variant = "autumn",
			styles = {
				comments = { italic = true, bold = false },
				-- functions = { italic = true },
				-- variables = { italic = false },
			},
		},
		config = function(_, opts)
			-- vim.o.termguicolors = true
			-- vim.o.background = "light"
			require("solarized").setup(opts)
			vim.cmd.colorscheme("solarized")
		end,
	},
	-- tabline
	{
		"akinsho/bufferline.nvim",
		version = "*",
		keys = {
			{ "<M-1>", "<cmd>BufferLineGoToBuffer 1<CR>", { desc = "Go to tab 1" } },
			{ "<M-2>", "<cmd>BufferLineGoToBuffer 2<CR>", { desc = "Go to tab 2" } },
			{ "<M-3>", "<cmd>BufferLineGoToBuffer 3<CR>", { desc = "Go to tab 3" } },
			{ "<M-4>", "<cmd>BufferLineGoToBuffer 4<CR>", { desc = "Go to tab 4" } },
			{ "<M-5>", "<cmd>BufferLineGoToBuffer 5<CR>", { desc = "Go to tab 5" } },
			{ "<leader><tab><left>", "<cmd>BufferLineMovePrev<CR>", { desc = "Move tab left" } },
			{ "<leader><tab><right>", "<cmd>BufferLineMoveNext<CR>", { desc = "Move tab right" } },
		},
		config = function()
			require("bufferline").setup({
				options = {
					numbers = "ordinal",
					indicator = {
						icon = "▎",
						style = "underline",
					},
					offsets = {
						{
							filetype = "NvimTree",
							text = "File Explorer",
							text_align = "left",
							separator = true,
						},
					},
				},
			})
		end,
	},
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "solarized_dark",
				},
				extensions = { "nvim-tree" },
			})
		end,
	},
	-- document outline (right sidebar, treesitter-backed for markdown)
	{
		"hedyhli/outline.nvim",
		cmd = { "Outline", "OutlineOpen", "OutlineFocus", "OutlineClose" },
		keys = {
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle Outline" },
		},
		opts = {
			outline_window = {
				position = "right",
				width = 15,
				relative_width = true,
				auto_close = false,
				focus_on_open = true,
			},
			outline_items = {
				show_symbol_details = true,
				highlight_hovered_item = true,
				auto_set_cursor = true,
			},
			symbol_folding = {
				autofold_depth = 1,
				auto_unfold = { hovered = true },
			},
			preview_window = {
				auto_preview = false,
			},
			providers = {
				markdown = {
					filetypes = { "markdown" },
				},
			},
		},
	},
	-- in-buffer markdown rendering (headings, lists, code blocks, tables)
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		ft = { "markdown" },
		opts = {},
	},
	-- show keybindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "classic",
			spec = {
				{ "<leader>c", group = " Code", mode = { "n", "x" } },
				{ "<leader>d", group = " Diagnosis", mode = { "n", "v" } },
				{ "<leader>f", group = " Find | File" },
				{ "<leader>g", group = " Git" },
				{ "<leader>s", group = " Session" },
				{ "<leader><tab>", group = " Tab" },
				{ "<leader>w", group = " Windows" },
				-- { "<leader>t", group = " Toggle" },
				-- { "<leader>W", group = " Workspace" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
