local config = {
	"folke/which-key.nvim",
	lazy = false,
	keys = {
		{ "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Show keymaps" },
	},
	config = function()
		require("which-key").setup({})
	end,
}

return config
