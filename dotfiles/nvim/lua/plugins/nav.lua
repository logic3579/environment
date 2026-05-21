return {
	-- fuzzy finder
	{
		"ibhagwan/fzf-lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "FzfLua",
		keys = {
			{ "<Leader>ff", "<cmd>FzfLua files<CR>", desc = "find files" },
			{ "<Leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "grep files" },
			{ "<leader>f/", "<cmd>FzfLua lgrep_curbuf<CR>", desc = "search current buffer" },
			{ "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "buffers" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "help tags" },
		},
		opts = {},
	},
	--  file explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<Leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-tree explorer" } },
		},
		config = function()
			require("nvim-tree").setup({})
		end,
	},
	-- seamless navigation between nvim splits and tmux panes (M-h/j/k/l)
	{
		"christoomey/vim-tmux-navigator",
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		init = function()
			vim.g.tmux_navigator_no_mappings = 1
		end,
		keys = {
			{ "<M-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Navigate Left (split/pane)" },
			{ "<M-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Navigate Down (split/pane)" },
			{ "<M-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Navigate Up (split/pane)" },
			{ "<M-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Navigate Right (split/pane)" },
		},
	},
	-- session
	{
		"rmagatti/auto-session",
		lazy = false,
		keys = {
			-- Will use Telescope if installed or a vim.ui.select picker otherwise
			{ "<leader>sw", "<cmd>AutoSession save<CR>", desc = "Session Save" },
			{ "<leader>ss", "<cmd>AutoSession search<CR>", desc = "Session Search" },
			{ "<leader>sp", "<cmd>AutoSession purgeOrphaned<CR>", desc = "Session PurgeOrphaned" },
			{ "<leader>sq", "<cmd>qa<CR>", desc = "Quit All" },
		},
		opts = {
			auto_save = false,
			-- auto_restore_last_session = false,
			-- allowed_dirs = { "/some/dir/", "/projects/*" },
			suppressed_dirs = { "/", "~/", "~/Projects", "~/Downloads" },
			session_lens = { picker = "fzf" },
		},
	},
}
