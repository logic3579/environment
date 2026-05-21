return {
	-- git signs in gutter
	{
		"lewis6991/gitsigns.nvim",
		keys = {
			{
				"<leader>gk",
				function()
					require("gitsigns").preview_hunk()
				end,
				desc = "Preview Hunk",
			},
			{
				"<leader>gp",
				function()
					require("gitsigns").nav_hunk("prev")
				end,
				desc = "Prev Hunk",
			},
			{
				"<leader>gn",
				function()
					require("gitsigns").nav_hunk("next")
				end,
				desc = "Next Hunk",
			},
		},
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged = {
					add = { text = "+" },
					change = { text = "~" },
					delete = { text = "_" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
				signs_staged_enable = true,
				signcolumn = true,
				numhl = true,
				linehl = false,
				word_diff = true,
			})
		end,
	},
	-- magit-like git interface
	{
		"NeogitOrg/neogit",
		dependencies = {
			"sindrets/diffview.nvim", -- optional - Diff integration
			"ibhagwan/fzf-lua", -- optional - picker integration
		},
		keys = {
			{
				"<leader>gg",
				function()
					require("neogit").open()
				end,
				desc = "Neogit Status",
			},
			{
				"<leader>gc",
				function()
					require("neogit").open({ "commit" })
				end,
				desc = "Neogit Commit popup",
			},
		},
		config = function()
			local neogit = require("neogit")
			neogit.setup({
				kind = "auto",
				integrations = {
					diffview = true,
					fzf_lua = true,
				},
			})
		end,
	},
}
