local config = {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	keys = {
		{ "<leader>cc", "<cmd>CodeCompanionChat<CR>", desc = "CodeCompanion chat" },
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		interactions = {
			chat = {
				adapter = "opencode",
			},
		},
	},
}

return config
