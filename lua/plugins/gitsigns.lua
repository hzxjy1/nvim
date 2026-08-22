local config = {
	"lewis6991/gitsigns.nvim",
	lazy = false,
	keys = {
		{ "<leader>rh", function() require("gitsigns").reset_hunk() end, mode = "v", desc = "Reset hunk" },
		{ "<leader>nh", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
		{ "<leader>ph", function() require("gitsigns").prev_hunk() end, desc = "Previous hunk" },
	},
	config = function()
		require("gitsigns").setup({
			current_line_blame = true,
			numhl = true,
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
		})
	end,
}

return config
