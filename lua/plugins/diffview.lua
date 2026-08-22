local config = {
	"sindrets/diffview.nvim",
	keys = {
		{ "<leader>do", "<cmd>DiffviewOpen<CR>", desc = "Diffview open" },
		{ "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Diffview close" },
	},
	config = function()
		require("diffview").setup({ use_icons = false })
	end,
}

return config
